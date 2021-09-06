import 'package:page_transition/page_transition.dart';
import 'package:enum_to_string/enum_to_string.dart';
import '../base_model.dart';

class PageArguments implements BaseModel {
  PageTransitionType? transitionType;
  dynamic data;

  PageArguments({
    this.transitionType,
    this.data,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'Transition': transitionType != null
          ? EnumToString.convertToString(transitionType)
          : null,
      'Data': data,
    };
  }
}
