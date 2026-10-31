/// translations.dart
class ApiTranslator {
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'failed': 'Something went wrong',
      'invalid_otp': 'Invalid OTP. Please try again.',
      'user_blocked': 'You cannot interact with this user',
      'something_went_wrong': 'Something went wrong',
      'user_already_exists': 'User already exists',
      'phone_already_exists': 'Phone number already exists',
      'otp_resend_success': 'OTP has been resent successfully',
      'no internet connection': 'No Internet Connection',
      'branch_closed_or_busy': 'The selected branch is closed or busy.',
      "failed_to_load_branches": "Failed to load branches",
      "delivery_not_available": "Delivery not available",
      "no_near_branch_found":
          "No branches nearby. Please choose diffrent address",
      "branch_currently_closed": "Sorry, this branch is currently closed",
      "branch_currently_busy":
          "Sorry, this branch is currently busy, please try again shortly",
      "order_type_not_available":
          "This order type is not available for the selected branch",
      "item_out_of_stock": "Item {itemName} is out of stock",
      "please_select_delivery_location": "Please select delivery location",
      "failed_to_create_payment_link": "Failed to create payment link",
      "payment_not_completed": "Payment was not completed",
      "no_address_specified": "No Address Specified",
      "price_min_error": "Price must be greater than 1 SAR",

      "points_exceed_available":
          "Entered points cannot exceed your available points.",
      "invalid_promo_code": "Invalid promo code",
    },

    'ar': {
      'failed': 'حدث خطأ ما',
      'invalid_otp': 'رمز التحقق غير صحيح. يرجى المحاولة مرة أخرى.',
      'user_blocked': 'لا يمكنك التفاعل مع هذا المستخدم',
      'something_went_wrong': 'حدث خطأ ما',
      'user_already_exists': 'المستخدم موجود بالفعل',
      'phone_already_exists': 'رقم الهاتف موجود بالفعل',
      'otp_resend_success': 'تمت إعادة إرسال رمز التحقق بنجاح',
      'no internet connection': 'لا يوجد اتصال بالإنترنت',
      'branch_closed_or_busy': 'الفرع المختار مغلق أو مشغول حالياً.',
      "failed_to_load_branches": "فشل تحميل الفروع",
      "delivery_not_available": "التوصيل غير متاح",
      "no_near_branch_found": "لا يوجد فرع قريب، يرجى اختيار عنوان مختلف",
      "branch_currently_closed": "عذراً، الفرع مغلق حالياً",
      "branch_currently_busy":
          "عذراً، الفرع مشغول حالياً، يرجى المحاولة لاحقاً",
      "order_type_not_available": "نوع الطلب غير متاح لهذا الفرع",
      "item_out_of_stock": "العنصر {itemName} غير متوفر في المخزون",
      "please_select_delivery_location": "الرجاء اختيار موقع التوصيل",
      "failed_to_create_payment_link": "فشل إنشاء رابط الدفع",
      "payment_not_completed": "لم تكتمل عملية الدفع",
      "no_address_specified": "لا يوجد عنوان محدد",
      "price_min_error": "يجب أن يكون السعر أكبر من 1 ريال سعودي",
      "points_exceed_available":
          "لا يمكن أن تتجاوز النقاط المدخلة النقاط المتاحة لديك.",
      "invalid_promo_code": "رمز الخصم غير صالح",
    },
  };

  static String translate(String key, String langCode) {
    return _translations[langCode]?[key.toLowerCase()] ??
        _translations['en']?[key.toLowerCase()] ??
        key;
  }
}
