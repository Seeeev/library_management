import 'package:get/get.dart';
import 'package:library_management/controllers/login_controller/auth_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(AuthController());
  }
}
