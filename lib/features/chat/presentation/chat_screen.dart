import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/services/flutter_toast_service.dart';
import 'package:date_app/core/services/in_app_notification_service.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/utils/chat_filter_helper.dart';
import 'package:date_app/core/widgets/animated_loader.dart';
import 'package:date_app/core/widgets/app_system_overlay.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/chat/bloc/chat_cubit.dart';
import 'package:date_app/features/chat/bloc/chat_state.dart';
import 'package:date_app/features/chat/repository/chat_repository.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'package:date_app/features/profile/repository/block_repository.dart';

import 'widgets/chat_app_bar.dart';
import 'widgets/chat_date_pill.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/chat_message_bubble.dart';

class ChatScreen extends StatelessWidget {
  final UserModel targetUser;

  const ChatScreen({super.key, required this.targetUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(
        chatRepository: getIt<ChatRepository>(),
        blockRepository: getIt<BlockRepository>(),
        targetUserId: targetUser.uid,
      ),
      child: ChatView(targetUser: targetUser),
    );
  }
}

class ChatView extends StatefulWidget {
  final UserModel targetUser;

  const ChatView({super.key, required this.targetUser});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  /// How close (in pixels) to the bottom the user must be for an incoming
  /// message to auto-scroll the list.
  static const double _nearBottomThreshold = 200;

  @override
  void initState() {
    super.initState();
    InAppNotificationService.currentActiveChatUserId = widget.targetUser.uid;
  }

  @override
  void dispose() {
    if (InAppNotificationService.currentActiveChatUserId ==
        widget.targetUser.uid) {
      InAppNotificationService.currentActiveChatUserId = null;
    }
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// The list is reversed (like WhatsApp), so the "bottom" is offset 0.
  void _scrollToBottom({bool useAnimation = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      if (useAnimation) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(0);
      }
    });
  }

  bool get _isNearBottom =>
      !_scrollController.hasClients ||
      _scrollController.offset < _nearBottomThreshold;

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    if (ChatFilterHelper.containsRestrictedContactInfo(text)) {
      ToastService.showError(context.tr.chatContactSharingBlocked);
      return;
    }

    context.read<ChatCubit>().sendMessage(text);
    _textController.clear();
    _scrollToBottom();
  }

  Future<void> _pickAndSendImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );
    if (picked != null && mounted) {
      context.read<ChatCubit>().sendImageMessage(File(picked.path));
      _scrollToBottom();
    }
  }

  Future<void> _handlePickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  'Share Photo',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                ),
                16.verticalSpace,
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_rounded,
                    color: AppColors.primary,
                  ),
                  title: AppText(
                    'Choose from Gallery',
                    color: context.textPrimary,
                    fontSize: 14,
                  ),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    await _pickAndSendImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.primary,
                  ),
                  title: AppText(
                    'Take a Photo',
                    color: context.textPrimary,
                    fontSize: 14,
                  ),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    await _pickAndSendImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: context.surfaceCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          title: AppText(
            'Block ${widget.targetUser.name}?',
            color: context.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          content: AppText(
            'They will no longer be able to message you or see your profile in Discover.',
            color: context.textSecondary,
            fontSize: 14,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: AppText('Cancel', color: context.textSecondary),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<ChatCubit>().blockUser();
                ToastService.showPrimary('Blocked ${widget.targetUser.name}');
              },
              child: const AppText(
                'Block',
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppSystemOverlay(
      child: Scaffold(
        backgroundColor: context.appBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(66.h),
          child: ChatAppBar(
            targetUser: widget.targetUser,
            onBlockTap: _showBlockDialog,
          ),
        ),
        body: SafeArea(
          bottom: true,
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<ChatCubit, ChatState>(
                  // Only react when a message is added, not on every state
                  // change (e.g. upload flags), so we never yank the user
                  // away from history they are reading.
                  listenWhen: (p, c) => p.messages.length != c.messages.length,
                  listener: (context, state) {
                    // The list is reversed, so on first load it already sits
                    // at the newest message. Only follow new messages when
                    // the user is already near the bottom.
                    if (_isNearBottom) {
                      _scrollToBottom();
                    }
                  },
                  builder: (context, state) {
                    if (state.isLoading && state.messages.isEmpty) {
                      return const Center(
                        child: BreathingOpacityLoader(size: 60),
                      );
                    }

                    if (state.messages.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(20.r),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  color: AppColors.primary,
                                  size: 40,
                                ),
                              ),
                              12.verticalSpace,
                              AppText(
                                'Conversation with ${widget.targetUser.name}',
                                color: context.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.center,
                              ),
                              6.verticalSpace,
                              AppText(
                                'Send a real message or photo to start connecting!',
                                color: context.textSecondary,
                                fontSize: 13,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      // Anchors the list to the bottom, like WhatsApp.
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        // Reversed list: index 0 is the newest message.
                        final chronoIndex = state.messages.length - 1 - index;
                        final msg = state.messages[chronoIndex];
                        final isMe = msg.senderId != widget.targetUser.uid;

                        final isFirstOfDay = chronoIndex == 0 ||
                            !ChatDatePill.isSameDay(
                              msg.timestamp.toLocal(),
                              state.messages[chronoIndex - 1].timestamp.toLocal(),
                            );

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (isFirstOfDay) ...[
                              ChatDatePill(date: msg.timestamp),
                              4.verticalSpace,
                            ],
                            ChatMessageBubble(
                              message: msg,
                              isMe: isMe,
                              userAvatar: widget.targetUser.profileImageUrl,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),

              // Uploading indicator
              BlocBuilder<ChatCubit, ChatState>(
                buildWhen: (p, c) => p.isUploadingImage != c.isUploadingImage,
                builder: (context, state) {
                  if (!state.isUploadingImage) return const SizedBox.shrink();
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    color: context.surfaceCard,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16.r,
                          height: 16.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        10.horizontalSpace,
                        AppText(
                          'Uploading photo...',
                          color: context.textSecondary,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Input field or Blocked banner
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state.isBlocked) {
                    return Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: context.surfaceCard,
                        border: Border(top: BorderSide(color: context.stroke)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.block_rounded,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: AppText(
                              'You have blocked this user.',
                              color: context.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<ChatCubit>().unblockUser();
                              ToastService.showPrimary(
                                'Unblocked ${widget.targetUser.name}',
                              );
                            },
                            child: const Text(
                              'Unblock',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ChatInputField(
                    controller: _textController,
                    onSend: _handleSend,
                    onPickImage: _handlePickImage,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
