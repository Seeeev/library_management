import 'package:get/get.dart';

class AuthController extends GetxController {
  var isPressed = false.obs;

  toggleLoginButton() {
    isPressed.value = !isPressed.value;
  }
}
