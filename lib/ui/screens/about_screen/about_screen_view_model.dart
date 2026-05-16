import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/ui/screens/how_it_works_screen/how_it_works_screen.dart';
import 'package:get/route_manager.dart';

class AboutScreenViewModel extends BaseViewModel {
  void onWantToLearnMorePressed() {
    Get.to(HowItWorksScreen());
  }
}
