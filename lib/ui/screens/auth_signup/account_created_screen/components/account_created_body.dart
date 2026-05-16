import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/account_created_view_model.dart';
import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/components/account_created_background.dart';
import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/components/account_created_check_icon.dart';
import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/components/account_created_content.dart';
import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/components/floating_shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AccountCreatedBody extends StatefulWidget {
  final AccountCreatedViewModel model;
  const AccountCreatedBody({super.key, required this.model});

  @override
  State<AccountCreatedBody> createState() => _AccountCreatedBodyState();
}

class _AccountCreatedBodyState extends State<AccountCreatedBody>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.model.initAnimations(this);
  }

  @override
  void dispose() {
    widget.model.disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return ModalProgressHUD(
      inAsyncCall: model.state == ViewState.busy,
      opacity: 0.3,
      color: AppColors.black,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: AnimatedBuilder(
          animation: Listenable.merge([
            model.backgroundController,
            model.checkController,
            model.contentController,
            model.floatingShapesController,
          ]),
          builder: (context, _) {
            return Stack(
              children: [
                AccountCreatedBackground(model: model),
                AccountCreatedFloatingShapes(model: model),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28.w),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0.5.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AccountCreatedCheckIcon(model: model),
                          100.verticalSpace,
                          AccountCreatedContent(model: model),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
