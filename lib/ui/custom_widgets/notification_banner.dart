import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationBanner extends StatefulWidget {
  final String title;
  final String body;
  final VoidCallback? onViewTap;

  const NotificationBanner({
    super.key,
    required this.title,
    required this.body,
    this.onViewTap,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String body,
    VoidCallback? onViewTap,
  }) {
    final overlay = Overlay.of(context);
    _insertEntry(overlay, title: title, body: body, onViewTap: onViewTap);
  }

  /// Use when you have [OverlayState] but no context with an Overlay ancestor
  /// (e.g. from NavigatorState.overlay when showing from a service).
  static void showWithOverlay(
    OverlayState overlay, {
    required String title,
    required String body,
    VoidCallback? onViewTap,
  }) {
    _insertEntry(overlay, title: title, body: body, onViewTap: onViewTap);
  }

  static void _insertEntry(
    OverlayState overlay, {
    required String title,
    required String body,
    VoidCallback? onViewTap,
  }) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _BannerOverlay(
        title: title,
        body: body,
        onViewTap: onViewTap,
        onDismiss: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 4), () {
      if (entry.mounted) entry.remove();
    });
  }

  @override
  State<NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner> {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _BannerOverlay extends StatefulWidget {
  final String title;
  final String body;
  final VoidCallback? onViewTap;
  final VoidCallback onDismiss;

  const _BannerOverlay({
    required this.title,
    required this.body,
    required this.onDismiss,
    this.onViewTap,
  });

  @override
  State<_BannerOverlay> createState() => _BannerOverlayState();
}

class _BannerOverlayState extends State<_BannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                _dismiss();
                widget.onViewTap?.call();
              },
              onVerticalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dy < -100) _dismiss();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // icon
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2CCFF),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text('🎉', style: TextStyle(fontSize: 22.sp)),
                      ),
                    ),
                    12.horizontalSpace,

                    // text
                    Expanded(
                      child: widget.body.isEmpty
                          ? ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [AppColors.primary, Color(0xFF5E2C4D)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              blendMode: BlendMode.srcIn,
                              child: Text(
                                widget.title,
                                style: AppTextStyles.bodyMediumSemiBold
                                    .copyWith(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          Color(0xFF5E2C4D),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ).createShader(bounds),
                                  blendMode: BlendMode.srcIn,
                                  child: Text(
                                    widget.title,
                                    style: AppTextStyles.bodyMediumSemiBold
                                        .copyWith(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                4.verticalSpace,
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          Color(0xFF5E2C4D),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ).createShader(bounds),
                                  blendMode: BlendMode.srcIn,
                                  child: Text(
                                    widget.body,
                                    style: AppTextStyles.paragraphSmallMedium
                                        .copyWith(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    12.horizontalSpace,
                    // view button
                    GestureDetector(
                      onTap: () {
                        _dismiss();
                        widget.onViewTap?.call();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, Color(0xFF5E2C4D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'View',
                          style: AppTextStyles.bodyMediumSemiBold.copyWith(
                            fontSize: 13.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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

// Join me on Enzer — Shop Now, Pay Later!
//Sign up using my referral link: https://enzer-app.chottu.link/enzero0i2026
