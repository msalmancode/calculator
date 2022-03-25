import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HistoryController extends GetxController {
  List<String> resultList = <String>[].obs;

  var isDarkMode = false.obs;
  var result = ''.obs;

  void addValue(String value) {
    resultList.add(value);
  }

  void clearList() {
    resultList.clear();
  }
}
