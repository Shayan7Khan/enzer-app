import 'package:enzer_app/ui/screens/welcome_screen/components/welcome_button.dart';
import 'package:enzer_app/ui/screens/welcome_screen/components/welcome_header.dart';
import 'package:enzer_app/ui/screens/welcome_screen/components/welcome_image.dart';
import 'package:enzer_app/ui/screens/welcome_screen/welcome_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WelcomeScreenViewModel(),
      child: Consumer<WelcomeScreenViewModel>(
        builder: (context, model, _) => Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFBF00FF), Color(0xFF5E2C4D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // top spacing
                  40.verticalSpace,

                  // white card in center
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 32.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const WelcomeHeader(),
                            const Expanded(child: WelcomeImage()),
                            WelcomeButtons(model: model),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // bottom spacing
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
