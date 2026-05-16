import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/ui/screens/root/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountCreatedViewModel extends BaseViewModel {
  // Animation Controllers
  late AnimationController backgroundController;
  late AnimationController checkController;
  late AnimationController contentController;
  late AnimationController floatingShapesController;

  // ─── Animations
  late Animation<double> checkScaleAnimation;
  late Animation<double> checkOpacityAnimation;
  late Animation<double> contentSlideAnimation;
  late Animation<double> contentOpacityAnimation;
  late Animation<double> backgroundAnimation;
  late Animation<double> floatingShapesAnimation;
  late Animation<double> pulseAnimation;

  // Init
  void initAnimations(TickerProvider vsync) {
    // Background fade
    backgroundController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    );
    backgroundAnimation = CurvedAnimation(
      parent: backgroundController,
      curve: Curves.easeOut,
    );

    // Check circle scale + bounce
    checkController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 700),
    );
    checkScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.2,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
    ]).animate(checkController);
    checkOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: checkController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Floating shapes drift
    floatingShapesController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    floatingShapesAnimation = CurvedAnimation(
      parent: floatingShapesController,
      curve: Curves.easeInOut,
    );

    // Content slide up
    contentController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 600),
    );
    contentSlideAnimation = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: contentController, curve: Curves.easeOut),
    );
    contentOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: contentController, curve: Curves.easeOut),
    );

    // Pulse on check icon (subtle)
    pulseAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.06), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.06, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: floatingShapesController,
            curve: Curves.easeInOut,
          ),
        );

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    backgroundController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    checkController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    contentController.forward();
  }

  //Actions
  void goToDashboard() {
    Get.offAll(() => RootScreen());
  }

  void disposeAnimations() {
    backgroundController.dispose();
    checkController.dispose();
    contentController.dispose();
    floatingShapesController.dispose();
  }
}
