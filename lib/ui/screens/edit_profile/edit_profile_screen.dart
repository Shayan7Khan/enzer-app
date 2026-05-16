import 'package:enzer_app/core/constants/image_path.dart';
import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/custom_widgets/custom_elevated_button.dart';
import 'package:enzer_app/ui/screens/edit_profile/edit_profile_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileViewModel(),
      child: Consumer<EditProfileViewModel>(
        builder: (context, model, _) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.busy,
          opacity: 0.3,
          color: AppColors.black,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.black,
                    size: 22.sp,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              title: Text(
                'Edit Profile',
                style: AppTextStyles.h5Bold.copyWith(color: AppColors.black),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _AvatarSection(model: model),
                  32.verticalSpace,
                  _ReadOnlyField(label: 'Full Name', value: model.userName),
                  20.verticalSpace,
                  _ReadOnlyField(label: 'NIC (National ID)', value: model.cnic),
                  20.verticalSpace,
                  _ReadOnlyPhoneField(phone: model.phone),
                  32.verticalSpace,
                  CustomElevatedButton(
                    text: 'Update',
                    onPressed: model.updateProfile,
                    isBold: true,
                  ),
                  24.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final EditProfileViewModel model;
  const _AvatarSection({required this.model});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Avatar circle
            Container(
              width: 146.r,
              height: 146.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF5B0090)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(child: _buildAvatar(model)),
                ),
              ),
            ),

            Positioned(
              bottom: 7,
              right: 7,
              child: GestureDetector(
                onTap: () => _showPhotoOptions(context, model),
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF5B0090)],
                    ),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    editPhotoIcon,
                    width: 24.r,
                    height: 24.r,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
        12.verticalSpace,
        GestureDetector(
          onTap: () => _showPhotoOptions(context, model),
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.primary, Color(0xFF5B0090)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: Text(
              'Change profile photo',
              style: AppTextStyles.bodyMediumSemiBold.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(EditProfileViewModel model) {
    if (model.selectedImage != null) {
      return Image.file(model.selectedImage!, fit: BoxFit.cover);
    }
    if (model.currentAvatarUrl != null && model.currentAvatarUrl!.isNotEmpty) {
      return Image.network(model.currentAvatarUrl!, fit: BoxFit.cover);
    }
    return Container(
      color: const Color(0xFFF0F0F0),
      child: Icon(Icons.person, size: 52.sp, color: AppColors.gray600),
    );
  }

  void _showPhotoOptions(BuildContext context, EditProfileViewModel model) {
    final hasPhoto =
        (model.currentAvatarUrl != null &&
            model.currentAvatarUrl!.isNotEmpty) ||
        model.selectedImage != null;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.gray300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            16.verticalSpace,
            if (!hasPhoto) ...[
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.primary,
                ),
                title: Text(
                  'Choose from gallery',
                  style: AppTextStyles.bodyMedium,
                ),
                onTap: () {
                  Get.back();
                  model.pickImage();
                },
              ),
            ] else ...[
              ListTile(
                leading: Icon(Icons.edit_outlined, color: AppColors.primary),
                title: Text('Update photo', style: AppTextStyles.bodyMedium),
                onTap: () {
                  Get.back();
                  model.pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  'Remove photo',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
                ),
                onTap: () {
                  Get.back();
                  model.onRemovePhoto();
                },
              ),
            ],
            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  const _ReadOnlyField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.gray800,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.gray300),
          ),
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.gray700,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyPhoneField extends StatelessWidget {
  final String phone;
  const _ReadOnlyPhoneField({required this.phone});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.gray800,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            border: Border.all(color: AppColors.gray300),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              phone,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray700,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
