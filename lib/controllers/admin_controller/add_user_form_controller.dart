import 'package:get/get.dart';

class AddUserController extends GetxController {
  var isEnabled = true.obs;

  enableButton() {
    isEnabled.value = true;
  }

  disableButton() {
    isEnabled.value = false;
  }
}
