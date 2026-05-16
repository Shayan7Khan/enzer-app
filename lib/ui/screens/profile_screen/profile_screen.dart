import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/ui/custom_widgets/custom_elevated_button.dart';
import 'package:enzer_app/ui/screens/profile_screen/components/profile_app_bar.dart';
import 'package:enzer_app/ui/screens/profile_screen/components/profile_card.dart';
import 'package:enzer_app/ui/screens/profile_screen/components/profile_delete_button.dart';
import 'package:enzer_app/ui/screens/profile_screen/components/profile_invites_section.dart';
import 'package:enzer_app/ui/screens/profile_screen/components/profile_logout_button.dart';
import 'package:enzer_app/ui/screens/profile_screen/components/profile_referral_section.dart';
import 'package:enzer_app/ui/screens/profile_screen/profile_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // Per-instance refresh key so multiple ProfileScreens can exist
  // in the widget tree (tab + pushed route) without duplicate GlobalKey errors.
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, model, _) => Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: ProfileAppBar(context: context),
          body: Stack(
            children: [
              RefreshIndicator(
                key: _refreshKey,
                color: AppColors.primary,
                onRefresh: model.loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileCard(model: model),
                      20.verticalSpace,
                      ProfileInvitesSection(model: model),
                      16.verticalSpace,
                      ProfileReferralSection(model: model),
                      16.verticalSpace,
                      CustomElevatedButton(
                        text: 'Share invite link',
                        onPressed: model.shareInviteLink,
                        prefixIcon: Icons.share_outlined,
                        isBold: true,
                      ),
                      12.verticalSpace,
                      LogoutButton(model: model),
                      12.verticalSpace,
                      DeleteButton(model: model),
                      18.verticalSpace,
                    ],
                  ),
                ),
              ),
              if (model.isRefreshing)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.primary50,
                    minHeight: 2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
