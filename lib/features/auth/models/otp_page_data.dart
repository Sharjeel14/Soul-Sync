import 'package:date_app/core/enums/signup_page_type.dart';

class OtpPageData {
  final Map<String, dynamic> data;
  final OtpPageRouteType pageType;
  final String? mobile;

  OtpPageData({required this.data, required this.pageType, this.mobile});
}
