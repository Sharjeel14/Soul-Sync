// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:date_app/core/constants/app_images.dart';
// import 'package:date_app/core/extensions/app_extensions.dart';
// import 'package:date_app/core/theme/app_colors.dart';

// void showCountryPickerBottomSheet(
//   BuildContext context,
//   Function(Country) onSelected, {
//   bool showPhoneCode = false,
// }) {
//   showCountryPicker(
//     context: context,
//     showPhoneCode: showPhoneCode,
//     countryListTheme: CountryListThemeData(
//       bottomSheetHeight: context.screenHeight * 0.85,
//       backgroundColor: AppColors.black,

//       searchTextStyle: const TextStyle(color: AppColors.white),
//       textStyle: const TextStyle(color: AppColors.white),
//       inputDecoration: InputDecoration(
//         hintStyle: TextStyle(color: AppColors.white),
//         hintText: context.tr.searchCountry,
//         prefixIcon: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.w),
//           child: SvgPicture.asset(AppImages.search, width: 25.r, height: 25.r),
//         ),
//         prefixIconConstraints: BoxConstraints(minWidth: 30, minHeight: 30),
//         fillColor: AppColors.black,
//         border: OutlineInputBorder(
//           borderSide: BorderSide(color: AppColors.white),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: AppColors.white),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: AppColors.primary),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//       ),
//     ),

//     onSelect: onSelected,
//   );
// }
