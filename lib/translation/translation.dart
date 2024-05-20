import 'package:get/get.dart';
import 'package:rain/translation/en_us.dart';
import 'package:rain/translation/vi_vn.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'vi_VN': ViVn().messages,
        'en_US': EnUs().messages,
      };
}
