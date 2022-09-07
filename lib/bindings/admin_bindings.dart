import 'package:get/get.dart';
import 'package:library_management/controllers/admin_controller/add_user_form_controller.dart';
import 'package:library_management/controllers/admin_controller/update_book_controller.dart';

class AdminBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(UpdateBookController());
    Get.put(AddUserController());
  }
}
