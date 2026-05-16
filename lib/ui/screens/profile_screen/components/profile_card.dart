import 'package:enzer_app/core/constants/image_path.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/profile_screen/profile_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileCard extends StatelessWidget {
  final ProfileViewModel model;
  const ProfileCard({super.key, required this.model});

  static Gradient _cardGradientForRole(String role) {
    switch (role) {
      case 'Premium':
        return const LinearGradient(
          colors: [Color(0xFFBF00FF), Color(0xFF5E2C4D)],
          begin: Alignment(-0.79, 0.62),
          end: Alignment(0.79, -0.62),
        );
      case 'Executive':
        return const LinearGradient(
          colors: [Color(0xFFCA3C0B), Color(0xFFFE7040)],
          begin: Alignment(-0.82, 0.57),
          end: Alignment(0.82, -0.57),
        );
      case 'Founder':
        return const LinearGradient(
          colors: [Color(0xFF27272A), Color(0xFF000000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default: // Starter
        return const LinearGradient(
          colors: [Color(0xFF6B7280), Color(0xFF4B5563)],
          begin: Alignment(-0.79, 0.62),
          end: Alignment(0.79, -0.62),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: _cardGradientForRole(model.roleBadge),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -13.h,
            left: 232.w,
            child: SvgPicture.asset(
              'assets/images/profile_vector.svg',
              fit: BoxFit.fitHeight,
              colorFilter: ColorFilter.mode(
                Colors.white.withValues(alpha: 0.15),
                BlendMode.srcIn,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileCardHeader(model: model),
                16.verticalSpace,
                Divider(
                  color: Colors.white.withValues(alpha: 0.3),
                  thickness: 1,
                ),
                16.verticalSpace,
                _ProfileCardStats(model: model),
              ],
            ),
          ),
          // Edit button
          Positioned(
            top: 13.h,
            right: 15.w,
            child: GestureDetector(
              onTap: model.getToEditScreen,
              child: Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _editButtonColorForRole(model.roleBadge),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: SvgPicture.asset(editIcon, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Color _editButtonColorForRole(String role) {
    switch (role) {
      case 'Premium':
        return const Color(0xFF7B00A8); // dark purple
      case 'Executive':
        return const Color(0xFFB04A1A); // dark orange
      case 'Founder':
        return const Color(0xFF3A3A3A); // dark grey
      default: // Starter
        return const Color(0xFF4B5563); // dark grey
    }
  }
}

class _ProfileCardHeader extends StatelessWidget {
  final ProfileViewModel model;
  const _ProfileCardHeader({required this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64.r,
          height: 64.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.25),
          ),
          child: ClipOval(
            child: model.avatarUrl != null && model.avatarUrl!.isNotEmpty
                ? Image.network(
                    model.avatarUrl!,
                    fit: BoxFit.cover,
                    width: 64.r,
                    height: 64.r,
                    errorBuilder: (_, _, _) =>
                        Icon(Icons.person, color: Colors.white, size: 55.sp),
                  )
                : Icon(Icons.person, color: Colors.white, size: 55.sp),
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatName(model.userName),
                style: AppTextStyles.h4SemiBold.copyWith(
                  color: AppColors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              6.verticalSpace,
              Text(
                _formatCnic(model.cnic),
                style: AppTextStyles.paragraphSmallRegular.copyWith(
                  color: AppColors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              8.verticalSpace,
              _RoleBadge(role: model.roleBadge),
            ],
          ),
        ),
      ],
    );
  }

  String _formatCnic(String cnic) {
    final digits = cnic.replaceAll('-', '');
    if (digits.length != 13) return cnic;
    return '${digits.substring(0, 5)}-${digits.substring(5, 12)}-${digits.substring(12)}';
  }
}

String _formatName(String fullName) {
  final parts = fullName.trim().split(' ');
  if (parts.length < 2) return fullName;
  final firstName = parts.first;
  final lastInitial = parts.last[0].toUpperCase();
  return '$firstName $lastInitial.';
}

/// Role tag: white bg, black text. Card container uses role gradients.
class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        role,
        style: AppTextStyles.paragraphSmallRegular.copyWith(
          color: AppColors.black,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProfileCardStats extends StatelessWidget {
  final ProfileViewModel model;
  const _ProfileCardStats({required this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatColumn(label: 'Rank', value: model.rank.toString()),
        Container(
          width: 1,
          height: 36.h,
          color: Colors.white.withValues(alpha: 0.3),
          margin: EdgeInsets.symmetric(horizontal: 30.w),
        ),
        _StatColumn(
          label: 'Total Invites',
          value: model.totalInvites.toString(),
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.paragraphSmallRegular.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        4.verticalSpace,
        Text(
          value,
          style: AppTextStyles.paragraphLargeSemiBold.copyWith(
            color: AppColors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
