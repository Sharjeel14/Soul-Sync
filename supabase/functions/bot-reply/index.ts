import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const OPENAI_URL = "https://api.openai.com/v1/chat/completions"

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders })
  }

  try {
    const rawBody = await req.text()
    console.log("Incoming raw payload:", rawBody)

    let payload: any = {}
    try {
      payload = JSON.parse(rawBody)
    } catch (_) {
      return new Response(JSON.stringify({ error: "Invalid JSON" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      })
    }

    // Support both Supabase Webhook wrapper { record: {...} } and direct JSON {...}
    const record = payload.record ?? payload

    const senderId = record.sender_id ?? record.senderId
    const receiverId = record.receiver_id ?? record.receiverId
    const text = record.text ?? record.message ?? ""
    const chatId = record.chat_id ?? record.chatId ?? (senderId && receiverId ? (senderId < receiverId ? `${senderId}_${receiverId}` : `${receiverId}_${senderId}`) : null)

    if (!senderId || !receiverId) {
      console.error("Missing sender_id or receiver_id in record:", record)
      return new Response(JSON.stringify({ error: "Missing sender_id or receiver_id", record }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      })
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    const openaiApiKey = Deno.env.get("OPENAI_API_KEY")

    if (!openaiApiKey) {
      console.error("OPENAI_API_KEY secret is missing in Edge Function secrets!")
      return new Response(JSON.stringify({ error: "Missing OPENAI_API_KEY" }), {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      })
    }

    const supabase = createClient(supabaseUrl, serviceRoleKey)

    // 1. Check if receiver is a bot
    const { data: botProfile, error: botErr } = await supabase
      .from("users")
      .select("uid, name, gender, bio, is_bot")
      .eq("uid", receiverId)
      .maybeSingle()

    console.log("Receiver profile lookup:", { botProfile, botErr })

    if (botErr || !botProfile || !botProfile.is_bot) {
      console.log(`User ${receiverId} is not a bot. Skipping.`)
      return new Response(JSON.stringify({ message: "Not a bot recipient. Skipped." }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      })
    }

    // Prevent bot replying to itself
    const { data: senderProfile } = await supabase
      .from("users")
      .select("is_bot")
      .eq("uid", senderId)
      .maybeSingle()

    if (senderProfile?.is_bot) {
      console.log("Sender is bot. Skipping loop.")
      return new Response(JSON.stringify({ message: "Sender is bot. Skipping loop." }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      })
    }

    // 2. Fetch last 6 messages in conversation for context
    const { data: history } = await supabase
      .from("messages")
      .select("sender_id, text, timestamp")
      .eq("chat_id", chatId)
      .order("timestamp", { ascending: true })
      .limit(6)

    const chatMessages = (history ?? []).map((m: any) => ({
      role: m.sender_id === botProfile.uid ? "assistant" : "user",
      content: m.text || "",
    }))

    // Add incoming user message if not yet present in history
    if (text && !chatMessages.some((m: any) => m.content === text)) {
      chatMessages.push({ role: "user", content: text })
    }

    // 3. System prompt with bot persona
    const systemPrompt = `You are ${botProfile.name}, a genuine person on a dating app.
Gender: ${botProfile.gender}
Bio / Personality: ${botProfile.bio || "Friendly and outgoing."}

Rules:
- Speak casually, warmly, and naturally like texting on a dating app.
- Reply in 1 to 2 sentences maximum.
- Never say you are an AI or bot. Stay in character 100%.
- Ask a natural question or react warmly to the user's message.`

    // 4. Request reply from OpenAI
    console.log(`Calling OpenAI for bot ${botProfile.name}...`)
    const openAiRes = await fetch(OPENAI_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${openaiApiKey}`,
      },
      body: JSON.stringify({
        model: "gpt-4o-mini",
        messages: [
          { role: "system", content: systemPrompt },
          ...chatMessages,
        ],
        max_completion_tokens: 150,
        temperature: 0.8,
      }),
    })

    if (!openAiRes.ok) {
      const errText = await openAiRes.text()
      console.error("OpenAI API error:", errText)
      return new Response(JSON.stringify({ error: "OpenAI error", details: errText }), {
        status: 502,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      })
    }

    const aiData = await openAiRes.json()
    const botReplyText = aiData?.choices?.[0]?.message?.content?.trim() || "Hey! Nice to meet you :)"
    console.log("Generated bot reply:", botReplyText)

    // 5. Mark user's message(s) as read by the bot
    const { error: markReadErr } = await supabase
      .from("messages")
      .update({ is_read: true })
      .eq("chat_id", chatId)
      .eq("sender_id", senderId)
      .eq("receiver_id", botProfile.uid)
      .eq("is_read", false)

    if (markReadErr) {
      console.warn("Could not mark user message as read:", markReadErr)
    } else {
      console.log(`Marked incoming messages from ${senderId} as read.`)
    }

    // 6. Insert bot reply into public.messages
    const replyMessage = {
      id: "msg_" + crypto.randomUUID().replace(/-/g, ""),
      chat_id: chatId,
      sender_id: botProfile.uid,
      receiver_id: senderId,
      text: botReplyText,
      image_url: "",
      timestamp: new Date().toISOString(),
      is_read: false,
    }

    const { error: insertErr } = await supabase.from("messages").insert(replyMessage)

    if (insertErr) {
      console.error("Failed to insert bot message:", insertErr)
      return new Response(JSON.stringify({ error: "Failed to insert message", details: insertErr }), {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      })
    }

    console.log("Successfully sent bot reply!")
    return new Response(JSON.stringify({ status: "success", reply: botReplyText }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 200,
    })
  } catch (err: any) {
    console.error("Unexpected error in Edge Function:", err)
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    })
  }
})
