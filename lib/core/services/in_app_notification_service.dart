import 'dart:async';

import 'package:date_app/core/widgets/app_cache_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/router/app_router.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/core/services/flutter_local_notification_service.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/features/chat/models/chat_message.dart';
import 'package:date_app/features/chat/repository/chat_repository.dart';
import 'package:date_app/features/global/models/user_model.dart';

class InAppNotificationService {
  static final InAppNotificationService _instance =
      InAppNotificationService._internal();
  factory InAppNotificationService() => _instance;
  InAppNotificationService._internal();

  /// User ID of the chat screen currently open (if any)
  static String? currentActiveChatUserId;

  StreamSubscription<ChatMessage>? _messageSub;
  OverlayEntry? _currentOverlay;
  Timer? _dismissTimer;

  void initialize() {
    _messageSub?.cancel();

    try {
      final chatRepo = getIt<ChatRepository>();
      _messageSub = chatRepo.onNewIncomingMessage.listen((msg) async {
        // If user is currently looking at this sender's chat, don't show overlay pill
        if (currentActiveChatUserId != null &&
            currentActiveChatUserId == msg.senderId) {
          return;
        }

        final sender = await chatRepo.getUserProfile(msg.senderId);
        if (sender != null) {
          showPill(sender: sender, message: msg);
        }
      });
    } catch (e) {
      debugPrint('InAppNotificationService init error: $e');
    }
  }

  void showPill({required UserModel sender, required ChatMessage message}) {
    final navState = navigatorKey.currentState;
    if (navState == null || navState.overlay == null) {
      return;
    }

    // Dismiss existing pill if already displayed
    dismiss();

    try {
      HapticFeedback.lightImpact();
    } catch (_) {}

    // Show system local notification as well (in case app goes to background shortly)
    try {
      getIt<NotificationService>().showLocalNotification(
        id: message.timestamp.millisecondsSinceEpoch.remainder(100000),
        title: sender.name,
        body: message.text.isNotEmpty ? message.text : '📷 Sent a photo',
        payload: sender.uid,
      );
    } catch (_) {}

    final overlay = navState.overlay!;
    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _NotificationPillWidget(
        sender: sender,
        message: message,
        onDismiss: dismiss,
        onTap: () {
          dismiss();
          final currentContext = navigatorKey.currentContext;
          if (currentContext != null && currentContext.mounted) {
            currentContext.push(AppRoutes.chat, extra: sender);
          }
        },
      ),
    );

    _currentOverlay = entry;
    overlay.insert(entry);

    _dismissTimer = Timer(const Duration(milliseconds: 3800), () {
      dismiss();
    });
  }

  void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (_currentOverlay != null) {
      _currentOverlay?.remove();
      _currentOverlay = null;
    }
  }

  void dispose() {
    _dismissTimer?.cancel();
    _messageSub?.cancel();
    dismiss();
  }
}

class _NotificationPillWidget extends StatefulWidget {
  final UserModel sender;
  final ChatMessage message;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationPillWidget({
    required this.sender,
    required this.message,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  State<_NotificationPillWidget> createState() =>
      _NotificationPillWidgetState();
}

class _NotificationPillWidgetState extends State<_NotificationPillWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _slideAnim = Tween<Offset>(begin: const Offset(0, -1.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
        );

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _dismissWithAnim() {
    _animController.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top > 0
        ? mediaQuery.padding.top
        : 24.h;

    final messagePreview = widget.message.text.trim().isNotEmpty
        ? widget.message.text.trim()
        : (widget.message.imageUrl != null ? '📷 Photo' : 'New message');

    return Positioned(
      top: topPadding + 6.h,
      left: 14.w,
      right: 14.w,
      child: Material(
        type: MaterialType.transparency,
        child: SlideTransition(
          position: _slideAnim,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: GestureDetector(
              onTap: widget.onTap,
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta != null &&
                    details.primaryDelta! < -4) {
                  _dismissWithAnim();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E28).withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.45),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Sender Avatar with Online Dot
                    Stack(
                      children: [
                        ClipOval(
                          child: widget.sender.profileImageUrl.isNotEmpty
                              ? AppCacheNetworkImage(
                                  widget.sender.profileImageUrl,
                                  width: 44.r,
                                  height: 44.r,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, url, error) =>
                                      _InitialsAvatar(name: widget.sender.name),
                                )
                              : _InitialsAvatar(name: widget.sender.name),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12.r,
                            height: 12.r,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00E676),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF1E1E28),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    12.horizontalSpace,

                    // Sender Name & Message Snippet
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.sender.name.split(',').first,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              6.horizontalSpace,
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 1.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  'now',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          3.verticalSpace,
                          Text(
                            messagePreview,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    8.horizontalSpace,

                    // Action Icon (Chat bubble)
                    Container(
                      padding: EdgeInsets.all(7.r),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chat_bubble_rounded,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String name;

  const _InitialsAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: 44.r,
      height: 44.r,
      color: AppColors.primary.withValues(alpha: 0.3),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 18.sp,
        ),
      ),
    );
  }
}
