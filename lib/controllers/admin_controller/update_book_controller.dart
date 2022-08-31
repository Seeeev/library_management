import 'package:get/get.dart';

class UpdateBookController extends GetxController {
  var enableFields = false.obs;
  var enableISBN = true.obs;
  var disableValidateButton = false.obs;
  var disableUpdateButton = true.obs;

  toggleFields() {
    enableFields.value = !enableFields.value;
  }

  toggleISBN() {
    enableISBN.value = !enableISBN.value;
  }

  toggleValidateButton() {
    disableValidateButton.value = !disableValidateButton.value;
  }

  toggleUpdateButton() {
    disableUpdateButton.value = !disableUpdateButton.value;
  }
}
