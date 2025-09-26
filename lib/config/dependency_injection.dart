import 'package:get/get.dart';
import '../services/prompt_service.dart';
import '../services/user_service.dart';
import '../services/template_service.dart';
import '../controllers/prompt_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/template_controller.dart';

class DependencyInjection {
  static void init() {
    // Services
    Get.put<PromptService>(PromptService(), permanent: true);
    Get.put<UserService>(UserService(), permanent: true);
    Get.put<TemplateService>(TemplateService(), permanent: true);

    // Controllers
    Get.put<PromptController>(PromptController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<NavigationController>(NavigationController(), permanent: true);
    Get.put<TemplateController>(TemplateController(), permanent: true);
  }
}
