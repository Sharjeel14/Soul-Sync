-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_net;

-- 2. ADD is_bot COLUMN TO users TABLE
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS is_bot BOOLEAN DEFAULT FALSE;

-- 3. FUNCTION: OPPOSITE-GENDER DISCOVERY
CREATE OR REPLACE FUNCTION public.get_discovery_profiles(p_uid text)
RETURNS SETOF public.users
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_gender text;
BEGIN
    SELECT LOWER(gender) INTO v_gender FROM public.users WHERE uid = p_uid;
    
    RETURN QUERY
    SELECT * FROM public.users
    WHERE uid <> p_uid
      AND (
          CASE 
              WHEN v_gender = 'male' THEN LOWER(gender) = 'female'
              WHEN v_gender = 'female' THEN LOWER(gender) = 'male'
              ELSE true
          END
      )
    ORDER BY created_at DESC;
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_discovery_profiles(text) TO authenticated, anon;

-- 4. SEED 40 BOT ACCOUNTS (20 MALE, 20 FEMALE)
DO $$
DECLARE
    v_password text := crypt('Password123!', gen_salt('bf'));
    m_names text[] := ARRAY[
        'James Wilson', 'Alexander Smith', 'Michael Brown', 'Daniel Miller', 'David Johnson',
        'Lucas Garcia', 'Ethan Davis', 'Oliver Martinez', 'Noah Taylor', 'William Anderson',
        'Benjamin Thomas', 'Henry White', 'Liam Harris', 'Mason Martin', 'Jack Thompson',
        'Samuel Robinson', 'Sebastian Clark', 'Elijah Lewis', 'Julian Walker', 'Gabriel Hall'
    ];
    m_bios text[] := ARRAY[
        'Architect & coffee enthusiast. Love weekend hiking.',
        'Tech founder, marathon runner, sushi lover.',
        'Photographer traveling the world. Let’s explore together.',
        'Musician & indie game developer. Always learning.',
        'Chef at local bistro. Will cook you dinner.',
        'Product designer. Passionate about art and books.',
        'Fitness coach. Good vibes and positive energy only.',
        'Mechanical engineer who loves classic cars and camping.',
        'Civil lawyer by day, jazz guitarist by night.',
        'Doctor with dog named Cooper. Let’s grab boba.',
        'Data scientist. Board games, cycling, sci-fi movies.',
        'Freelance writer. Tell me your favorite book.',
        'Adventure sports fan, snowboarder, dog dad.',
        'Landscape architect. Plant lover and brunch hunter.',
        'Financial analyst. Weekend surfer and podcast host.',
        'High school teacher. Theater and museum fan.',
        'Software engineer. Coffee, vinyl records, cats.',
        'Biologist & nature lover. Looking for genuine connection.',
        'Graphic artist & comic collector. Vinyl and matcha.',
        'Pilot. Always ready for next spontaneous trip.'
    ];
    m_photos text[] := ARRAY[
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=600',
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=600',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600',
        'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=600',
        'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=600',
        'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=600',
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600',
        'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=600',
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=600',
        'https://images.unsplash.com/photo-1480429370139-e0132c086e2a?w=600',
        'https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?w=600',
        'https://images.unsplash.com/photo-1528892952291-009c663ce843?w=600',
        'https://images.unsplash.com/photo-1463453091185-61582044d556?w=600',
        'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=600',
        'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=600',
        'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=600',
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=600',
        'https://images.unsplash.com/photo-1513956589380-bad6acb9b9d4?w=600',
        'https://images.unsplash.com/photo-1521119989659-a83eee488004?w=600',
        'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?w=600'
    ];

    f_names text[] := ARRAY[
        'Sophia Miller', 'Emma Johnson', 'Olivia Williams', 'Isabella Brown', 'Mia Jones',
        'Charlotte Davis', 'Amelia Wilson', 'Harper Taylor', 'Evelyn Anderson', 'Abigail Thomas',
        'Emily Jackson', 'Elizabeth White', 'Avery Harris', 'Sofia Martin', 'Ella Thompson',
        'Scarlett Robinson', 'Grace Clark', 'Chloe Rodriguez', 'Victoria Lewis', 'Aria Lee'
    ];
    f_bios text[] := ARRAY[
        'Yoga instructor & plant mom. Looking for coffee partner.',
        'UX designer who loves art galleries and matcha lattes.',
        'Pediatric nurse with golden retriever. Road trips are life.',
        'Pastry chef. I make amazing croissants. Wine fan.',
        'Journalist & podcast host. Tell me your story.',
        'Veterinarian. Animal lover, hiker, amateur potter.',
        'Fashion stylist & thrifting queen. Good conversation matters.',
        'Software engineer. Video games, gym, tacos.',
        'Marketing manager. Sunday farmer markets & beach walks.',
        'Dance teacher. Bright energy and spontaneous adventures.',
        'Interior designer. Minimalist aesthetic, maximalist heart.',
        'Clinical psychologist. Deep conversations over tea.',
        'Landscape painter. Nature is my studio.',
        'Biomedical researcher. Science nerd with passion for cooking.',
        'Music producer. Indie bands and night drives.',
        'High school counselor. Book lover, pottery maker.',
        'Content creator. Travel, photography, specialty coffee.',
        'Sommelier. Wine tastings, dinner parties, jazz.',
        'Florist. Living life in full bloom. Let’s get dessert.',
        'Civil engineer. Cycling, hiking, board games on Friday.'
    ];
    f_photos text[] := ARRAY[
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=600',
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=600',
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=600',
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=600',
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=600',
        'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=600',
        'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=600',
        'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=600',
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600',
        'https://images.unsplash.com/photo-1519742866993-66d3cfef4bbd?w=600',
        'https://images.unsplash.com/photo-1548142813-c348350df52b?w=600',
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=600',
        'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=600',
        'https://images.unsplash.com/photo-1520813792240-56fc4a3765a7?w=600',
        'https://images.unsplash.com/photo-1506953823976-52e1fdc0149a?w=600',
        'https://images.unsplash.com/photo-1516585427167-9f4af9627e6c?w=600',
        'https://images.unsplash.com/photo-1524638431109-93d95c968f03?w=600',
        'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?w=600',
        'https://images.unsplash.com/photo-1530785602389-0759fbee0e77?w=600',
        'https://images.unsplash.com/photo-1541823709867-1b206113eafd?w=600'
    ];

    v_uid uuid;
    v_email text;
    i int;
BEGIN
    -- 20 Male Accounts
    FOR i IN 1..20 LOOP
        v_email := 'male' || i || '@test.com';
        
        -- Find existing auth user or create new uuid
        SELECT id INTO v_uid FROM auth.users WHERE email = v_email LIMIT 1;
        IF v_uid IS NULL THEN
            v_uid := gen_random_uuid();
            BEGIN
                INSERT INTO auth.users (
                    id, aud, role, email, encrypted_password, email_confirmed_at,
                    raw_app_meta_data, raw_user_meta_data, created_at, updated_at
                ) VALUES (
                    v_uid, 'authenticated', 'authenticated', v_email,
                    v_password, NOW(),
                    '{"provider":"email","providers":["email"]}'::jsonb,
                    jsonb_build_object('name', m_names[i], 'gender', 'male', 'profile_image_url', m_photos[i]),
                    NOW(), NOW()
                );
            EXCEPTION WHEN OTHERS THEN
                -- If auth table has custom constraints, continue safely
            END;
        END IF;

        -- Ensure row exists in public.users
        INSERT INTO public.users (uid, name, email, gender, profile_image_url, bio, dob, is_email_verified, is_bot)
        VALUES (
            v_uid::text, m_names[i], v_email, 'male',
            m_photos[i], m_bios[i], (1990 + (i % 12)) || '-05-15', true, true
        ) ON CONFLICT (uid) DO UPDATE SET
            name = EXCLUDED.name,
            gender = 'male',
            profile_image_url = EXCLUDED.profile_image_url,
            bio = EXCLUDED.bio,
            dob = EXCLUDED.dob,
            is_bot = true;
    END LOOP;

    -- 20 Female Accounts
    FOR i IN 1..20 LOOP
        v_email := 'female' || i || '@test.com';
        
        -- Find existing auth user or create new uuid
        SELECT id INTO v_uid FROM auth.users WHERE email = v_email LIMIT 1;
        IF v_uid IS NULL THEN
            v_uid := gen_random_uuid();
            BEGIN
                INSERT INTO auth.users (
                    id, aud, role, email, encrypted_password, email_confirmed_at,
                    raw_app_meta_data, raw_user_meta_data, created_at, updated_at
                ) VALUES (
                    v_uid, 'authenticated', 'authenticated', v_email,
                    v_password, NOW(),
                    '{"provider":"email","providers":["email"]}'::jsonb,
                    jsonb_build_object('name', f_names[i], 'gender', 'female', 'profile_image_url', f_photos[i]),
                    NOW(), NOW()
                );
            EXCEPTION WHEN OTHERS THEN
                -- If auth table has custom constraints, continue safely
            END;
        END IF;

        -- Ensure row exists in public.users
        INSERT INTO public.users (uid, name, email, gender, profile_image_url, bio, dob, is_email_verified, is_bot)
        VALUES (
            v_uid::text, f_names[i], v_email, 'female',
            f_photos[i], f_bios[i], (1992 + (i % 12)) || '-08-20', true, true
        ) ON CONFLICT (uid) DO UPDATE SET
            name = EXCLUDED.name,
            gender = 'female',
            profile_image_url = EXCLUDED.profile_image_url,
            bio = EXCLUDED.bio,
            dob = EXCLUDED.dob,
            is_bot = true;
    END LOOP;
END $$;
