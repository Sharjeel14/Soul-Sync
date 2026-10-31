import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @createBowl.
  ///
  /// In en, this message translates to:
  /// **'Create Bowl'**
  String get createBowl;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @otpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get otpVerificationTitle;

  /// No description provided for @otpVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4 digit PIN code sent to your\nphone number'**
  String get otpVerificationSubtitle;

  /// No description provided for @otpResendPrefix.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t Receive Code ? '**
  String get otpResendPrefix;

  /// No description provided for @otpResendAgain.
  ///
  /// In en, this message translates to:
  /// **'Resend Again'**
  String get otpResendAgain;

  /// No description provided for @loginToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Login to Your Account'**
  String get loginToYourAccount;

  /// No description provided for @newToMyDating.
  ///
  /// In en, this message translates to:
  /// **'New to MyDating? '**
  String get newToMyDating;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get createYourAccount;

  /// No description provided for @eng.
  ///
  /// In en, this message translates to:
  /// **'Eng'**
  String get eng;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @mediaPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow Media Access'**
  String get mediaPermissionTitle;

  /// No description provided for @mediaPermissionDesc.
  ///
  /// In en, this message translates to:
  /// **'We need access to your camera and photos to upload images.'**
  String get mediaPermissionDesc;

  /// No description provided for @allowAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow Access'**
  String get allowAccess;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// No description provided for @selectSource.
  ///
  /// In en, this message translates to:
  /// **'Select Source'**
  String get selectSource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search Country'**
  String get searchCountry;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name*'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameHint;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile*'**
  String get mobile;

  /// No description provided for @enterYourMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'+966 50 123 4567'**
  String get enterYourMobileNumber;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth (Optional)'**
  String get dateOfBirth;

  /// No description provided for @dateOfBirthHint.
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get dateOfBirthHint;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterVerificationCode;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4 digit PIN code sent to your phone number'**
  String get otpSubtitle;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t Receive Code ? '**
  String get didntReceiveCode;

  /// No description provided for @resendAgain.
  ///
  /// In en, this message translates to:
  /// **'Resend Again'**
  String get resendAgain;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get navMenu;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @yourBowlBalance.
  ///
  /// In en, this message translates to:
  /// **'YOUR BOWL BALANCE'**
  String get yourBowlBalance;

  /// No description provided for @bowls.
  ///
  /// In en, this message translates to:
  /// **'bowls'**
  String get bowls;

  /// No description provided for @bowlsWaiting.
  ///
  /// In en, this message translates to:
  /// **'You\'ve got 3 bowls waiting.'**
  String get bowlsWaiting;

  /// No description provided for @chooseYourPack.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE YOUR PACK.'**
  String get chooseYourPack;

  /// No description provided for @ceremonialGrade.
  ///
  /// In en, this message translates to:
  /// **'CEREMONIAL GRADE • FRESH DAILY'**
  String get ceremonialGrade;

  /// No description provided for @matchaIsHere.
  ///
  /// In en, this message translates to:
  /// **'MATCHA\nIS HERE.'**
  String get matchaIsHere;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @oteRewards.
  ///
  /// In en, this message translates to:
  /// **'OTE REWARDS'**
  String get oteRewards;

  /// No description provided for @trendingRightNow.
  ///
  /// In en, this message translates to:
  /// **'TRENDING RIGHT NOW'**
  String get trendingRightNow;

  /// No description provided for @whatEveryoneOrdering.
  ///
  /// In en, this message translates to:
  /// **'What everyone\'s ordering'**
  String get whatEveryoneOrdering;

  /// No description provided for @greenGoddess.
  ///
  /// In en, this message translates to:
  /// **'Green Goddess'**
  String get greenGoddess;

  /// No description provided for @greenGoddessDesc.
  ///
  /// In en, this message translates to:
  /// **'Kale, avocado, hemp seeds'**
  String get greenGoddessDesc;

  /// No description provided for @powerBowl.
  ///
  /// In en, this message translates to:
  /// **'Power Bowl'**
  String get powerBowl;

  /// No description provided for @powerBowlDesc.
  ///
  /// In en, this message translates to:
  /// **'Quinoa, chicken, tahini'**
  String get powerBowlDesc;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'CUSTOM'**
  String get custom;

  /// No description provided for @buildYourBowl.
  ///
  /// In en, this message translates to:
  /// **'Build your bowl.'**
  String get buildYourBowl;

  /// No description provided for @noRulesJustGoodChoices.
  ///
  /// In en, this message translates to:
  /// **'No rules. Just good choices.'**
  String get noRulesJustGoodChoices;

  /// No description provided for @startBuilding.
  ///
  /// In en, this message translates to:
  /// **'Start building'**
  String get startBuilding;

  /// No description provided for @tabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tabAll;

  /// No description provided for @tabSalads.
  ///
  /// In en, this message translates to:
  /// **'Salads'**
  String get tabSalads;

  /// No description provided for @tabBowls.
  ///
  /// In en, this message translates to:
  /// **'Bowls'**
  String get tabBowls;

  /// No description provided for @tabWraps.
  ///
  /// In en, this message translates to:
  /// **'Wraps'**
  String get tabWraps;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get deliveryAddress;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @pickFrom.
  ///
  /// In en, this message translates to:
  /// **'Pick From'**
  String get pickFrom;

  /// No description provided for @orderFrom.
  ///
  /// In en, this message translates to:
  /// **'Order From'**
  String get orderFrom;

  /// No description provided for @buildingKingFahadRd.
  ///
  /// In en, this message translates to:
  /// **'Building 2, King Fahad Rd'**
  String get buildingKingFahadRd;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @makeYourOwn.
  ///
  /// In en, this message translates to:
  /// **'Make Your Own'**
  String get makeYourOwn;

  /// No description provided for @makeYourOwnDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your perfect salad or warm bowl by choosing ingredients'**
  String get makeYourOwnDesc;

  /// No description provided for @warmBowls.
  ///
  /// In en, this message translates to:
  /// **'Warm Bowls'**
  String get warmBowls;

  /// No description provided for @warmBowlsDesc.
  ///
  /// In en, this message translates to:
  /// **'Warm, wholesome, and packed with real nutrition'**
  String get warmBowlsDesc;

  /// No description provided for @salads.
  ///
  /// In en, this message translates to:
  /// **'Salads'**
  String get salads;

  /// No description provided for @saladsDesc.
  ///
  /// In en, this message translates to:
  /// **'Fresh greens, vibrant fruits, pure nourishment'**
  String get saladsDesc;

  /// No description provided for @proteinBalls.
  ///
  /// In en, this message translates to:
  /// **'Protein Balls'**
  String get proteinBalls;

  /// No description provided for @proteinBallsDesc.
  ///
  /// In en, this message translates to:
  /// **'A clean, protein-packed bite for guilt-free snacking'**
  String get proteinBallsDesc;

  /// No description provided for @softServeAcai.
  ///
  /// In en, this message translates to:
  /// **'Soft Serve / Acai'**
  String get softServeAcai;

  /// No description provided for @softServeAcaiDesc.
  ///
  /// In en, this message translates to:
  /// **'Açaí power blended into a cold, silky treat'**
  String get softServeAcaiDesc;

  /// No description provided for @drinksStimulate.
  ///
  /// In en, this message translates to:
  /// **'Drinks / Stimulate'**
  String get drinksStimulate;

  /// No description provided for @drinksStimulateDesc.
  ///
  /// In en, this message translates to:
  /// **'Smooth stimulation without the crash'**
  String get drinksStimulateDesc;

  /// No description provided for @drinksIndulge.
  ///
  /// In en, this message translates to:
  /// **'Drinks / Indulge'**
  String get drinksIndulge;

  /// No description provided for @drinksIndulgeDesc.
  ///
  /// In en, this message translates to:
  /// **'Decadent flavors, conscious ingredients'**
  String get drinksIndulgeDesc;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @enterYourMobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your Mobile Number'**
  String get enterYourMobileNumberLabel;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @yourCart.
  ///
  /// In en, this message translates to:
  /// **'YOUR CART'**
  String get yourCart;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'ITEMS'**
  String get items;

  /// No description provided for @deliveringTo.
  ///
  /// In en, this message translates to:
  /// **'Delivering To'**
  String get deliveringTo;

  /// No description provided for @addressLine1.
  ///
  /// In en, this message translates to:
  /// **'Building 2, King Fahad Rd'**
  String get addressLine1;

  /// No description provided for @addressLine2.
  ///
  /// In en, this message translates to:
  /// **'Riyadh, Saudi Arabia'**
  String get addressLine2;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @customSaladBowl.
  ///
  /// In en, this message translates to:
  /// **'Custom Salad Bowl'**
  String get customSaladBowl;

  /// No description provided for @price42Sr.
  ///
  /// In en, this message translates to:
  /// **'42 SR'**
  String get price42Sr;

  /// No description provided for @base.
  ///
  /// In en, this message translates to:
  /// **'Base:'**
  String get base;

  /// No description provided for @baseValue.
  ///
  /// In en, this message translates to:
  /// **'Kale, Spinach'**
  String get baseValue;

  /// No description provided for @proteins.
  ///
  /// In en, this message translates to:
  /// **'Proteins:'**
  String get proteins;

  /// No description provided for @proteinsValue.
  ///
  /// In en, this message translates to:
  /// **'Grilled Chicken'**
  String get proteinsValue;

  /// No description provided for @toppings.
  ///
  /// In en, this message translates to:
  /// **'Toppings:'**
  String get toppings;

  /// No description provided for @toppingsValue.
  ///
  /// In en, this message translates to:
  /// **'Cherry Tomatoes, Avocado, Feta Cheese'**
  String get toppingsValue;

  /// No description provided for @dressing.
  ///
  /// In en, this message translates to:
  /// **'Dressing:'**
  String get dressing;

  /// No description provided for @dressingValue.
  ///
  /// In en, this message translates to:
  /// **'Lemon Tahini'**
  String get dressingValue;

  /// No description provided for @cal.
  ///
  /// In en, this message translates to:
  /// **'CAL'**
  String get cal;

  /// No description provided for @calValue.
  ///
  /// In en, this message translates to:
  /// **'645'**
  String get calValue;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'PROTEIN'**
  String get protein;

  /// No description provided for @proteinValue.
  ///
  /// In en, this message translates to:
  /// **'52g'**
  String get proteinValue;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'CARBS'**
  String get carbs;

  /// No description provided for @carbsValue.
  ///
  /// In en, this message translates to:
  /// **'32g'**
  String get carbsValue;

  /// No description provided for @fats.
  ///
  /// In en, this message translates to:
  /// **'FATS'**
  String get fats;

  /// No description provided for @fatsValue.
  ///
  /// In en, this message translates to:
  /// **'45g'**
  String get fatsValue;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @totalNutrition.
  ///
  /// In en, this message translates to:
  /// **'TOTAL NUTRITION'**
  String get totalNutrition;

  /// No description provided for @useSubscription.
  ///
  /// In en, this message translates to:
  /// **'Use Subscription'**
  String get useSubscription;

  /// No description provided for @mealBalance.
  ///
  /// In en, this message translates to:
  /// **'Meal Balance'**
  String get mealBalance;

  /// No description provided for @mealCountTwo.
  ///
  /// In en, this message translates to:
  /// **'2 Meals'**
  String get mealCountTwo;

  /// No description provided for @mealsConsumedInThisOrder.
  ///
  /// In en, this message translates to:
  /// **'Meals consumed in this order:'**
  String get mealsConsumedInThisOrder;

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// No description provided for @redeemPoints.
  ///
  /// In en, this message translates to:
  /// **'Redeem Points'**
  String get redeemPoints;

  /// No description provided for @getSarForPoints.
  ///
  /// In en, this message translates to:
  /// **'Get 1 SAR for every {points} Points'**
  String getSarForPoints(Object points);

  /// No description provided for @pointsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Points Available'**
  String get pointsAvailable;

  /// No description provided for @pointsValue.
  ///
  /// In en, this message translates to:
  /// **'150 pts'**
  String get pointsValue;

  /// No description provided for @enterPointsToRedeem.
  ///
  /// In en, this message translates to:
  /// **'Enter Points to Redeem'**
  String get enterPointsToRedeem;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @enterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Coupon Code'**
  String get enterCouponCode;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @subTotal.
  ///
  /// In en, this message translates to:
  /// **'Sub Total'**
  String get subTotal;

  /// No description provided for @subTotalValue.
  ///
  /// In en, this message translates to:
  /// **'42 SR'**
  String get subTotalValue;

  /// No description provided for @subscriptionMeals.
  ///
  /// In en, this message translates to:
  /// **'Subscription Meals x1'**
  String get subscriptionMeals;

  /// No description provided for @subscriptionMealsValue.
  ///
  /// In en, this message translates to:
  /// **'-20 SR'**
  String get subscriptionMealsValue;

  /// No description provided for @pointsRedeemed.
  ///
  /// In en, this message translates to:
  /// **'Points Redeemed (100)'**
  String get pointsRedeemed;

  /// No description provided for @pointsRedeemedValue.
  ///
  /// In en, this message translates to:
  /// **'-1 SR'**
  String get pointsRedeemedValue;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @discountValue.
  ///
  /// In en, this message translates to:
  /// **'21 SR'**
  String get discountValue;

  /// No description provided for @pointsDiscount.
  ///
  /// In en, this message translates to:
  /// **'Points Discount'**
  String get pointsDiscount;

  /// No description provided for @promoDiscount.
  ///
  /// In en, this message translates to:
  /// **'Promo Discount'**
  String get promoDiscount;

  /// No description provided for @afterRedeemSubTotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal (After Redeem)'**
  String get afterRedeemSubTotal;

  /// No description provided for @afterPromoSubTotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal (After Promo)'**
  String get afterPromoSubTotal;

  /// No description provided for @redeemPointBalance.
  ///
  /// In en, this message translates to:
  /// **'Redeem Point Balance'**
  String get redeemPointBalance;

  /// No description provided for @redemptionRate.
  ///
  /// In en, this message translates to:
  /// **'Redemption Rate'**
  String get redemptionRate;

  /// No description provided for @minimumOrderPriceError.
  ///
  /// In en, this message translates to:
  /// **'Order total must be greater than 1 SAR to checkout.'**
  String get minimumOrderPriceError;

  /// No description provided for @pointsExceedsCurrent.
  ///
  /// In en, this message translates to:
  /// **'Points exceed current balance'**
  String get pointsExceedsCurrent;

  /// No description provided for @vat.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get vat;

  /// No description provided for @vatValue.
  ///
  /// In en, this message translates to:
  /// **'3 SR'**
  String get vatValue;

  /// No description provided for @deliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get deliveryFee;

  /// No description provided for @deliveryFeeValue.
  ///
  /// In en, this message translates to:
  /// **'5 SR'**
  String get deliveryFeeValue;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalValue.
  ///
  /// In en, this message translates to:
  /// **'29 SR'**
  String get totalValue;

  /// No description provided for @proceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckout;

  /// No description provided for @createYourOwn.
  ///
  /// In en, this message translates to:
  /// **'Create Your Own'**
  String get createYourOwn;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @statCal.
  ///
  /// In en, this message translates to:
  /// **'Cal'**
  String get statCal;

  /// No description provided for @statPro.
  ///
  /// In en, this message translates to:
  /// **'Prot'**
  String get statPro;

  /// No description provided for @statCar.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get statCar;

  /// No description provided for @statFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get statFat;

  /// No description provided for @continueLable.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLable;

  /// No description provided for @price39Sar.
  ///
  /// In en, this message translates to:
  /// **'39 SAR'**
  String get price39Sar;

  /// No description provided for @section_base_title.
  ///
  /// In en, this message translates to:
  /// **'1. Select Your Base'**
  String get section_base_title;

  /// No description provided for @section_base_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select one from either Salad or warm bowl'**
  String get section_base_subtitle;

  /// No description provided for @subgroup_saladBase.
  ///
  /// In en, this message translates to:
  /// **'Salad Base'**
  String get subgroup_saladBase;

  /// No description provided for @subgroup_warmBowlBase.
  ///
  /// In en, this message translates to:
  /// **'Warm Bowl Base'**
  String get subgroup_warmBowlBase;

  /// No description provided for @ing_romaineLetuce.
  ///
  /// In en, this message translates to:
  /// **'Romaine Lettuce'**
  String get ing_romaineLetuce;

  /// No description provided for @ing_icebergLettuce.
  ///
  /// In en, this message translates to:
  /// **'Iceberg Lettuce'**
  String get ing_icebergLettuce;

  /// No description provided for @ing_rocca.
  ///
  /// In en, this message translates to:
  /// **'Rocca'**
  String get ing_rocca;

  /// No description provided for @ing_kale.
  ///
  /// In en, this message translates to:
  /// **'Kale'**
  String get ing_kale;

  /// No description provided for @ing_otsRice.
  ///
  /// In en, this message translates to:
  /// **'OTS Rice'**
  String get ing_otsRice;

  /// No description provided for @ing_whiteRice.
  ///
  /// In en, this message translates to:
  /// **'White Rice'**
  String get ing_whiteRice;

  /// No description provided for @ing_cauliflowerRice.
  ///
  /// In en, this message translates to:
  /// **'Cauliflower Rice'**
  String get ing_cauliflowerRice;

  /// No description provided for @section_fresh_title.
  ///
  /// In en, this message translates to:
  /// **'2. Choose Fresh Ingredients'**
  String get section_fresh_title;

  /// No description provided for @section_fresh_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose 1 Ingredient'**
  String get section_fresh_subtitle;

  /// No description provided for @section_fresh_additionalCost.
  ///
  /// In en, this message translates to:
  /// **'Additional Ingredients cost + 2 SAR'**
  String get section_fresh_additionalCost;

  /// No description provided for @ing_radish.
  ///
  /// In en, this message translates to:
  /// **'Radish'**
  String get ing_radish;

  /// No description provided for @ing_olives.
  ///
  /// In en, this message translates to:
  /// **'Olives'**
  String get ing_olives;

  /// No description provided for @ing_greenOnion.
  ///
  /// In en, this message translates to:
  /// **'Green Onion'**
  String get ing_greenOnion;

  /// No description provided for @ing_cabbage.
  ///
  /// In en, this message translates to:
  /// **'Cabbage'**
  String get ing_cabbage;

  /// No description provided for @ing_greenBellPepper.
  ///
  /// In en, this message translates to:
  /// **'Green Bell Pepper'**
  String get ing_greenBellPepper;

  /// No description provided for @ing_carrots.
  ///
  /// In en, this message translates to:
  /// **'Carrots'**
  String get ing_carrots;

  /// No description provided for @ing_cucumberBeetroot.
  ///
  /// In en, this message translates to:
  /// **'Cucumber Beetroot'**
  String get ing_cucumberBeetroot;

  /// No description provided for @ing_cherryTomatoes.
  ///
  /// In en, this message translates to:
  /// **'Cherry Tomatoes'**
  String get ing_cherryTomatoes;

  /// No description provided for @ing_corn.
  ///
  /// In en, this message translates to:
  /// **'Corn'**
  String get ing_corn;

  /// No description provided for @ing_blackBeans.
  ///
  /// In en, this message translates to:
  /// **'Black Beans'**
  String get ing_blackBeans;

  /// No description provided for @ing_chickpeas.
  ///
  /// In en, this message translates to:
  /// **'Chickpeas'**
  String get ing_chickpeas;

  /// No description provided for @ing_pickles.
  ///
  /// In en, this message translates to:
  /// **'Pickles'**
  String get ing_pickles;

  /// No description provided for @ing_redBeans.
  ///
  /// In en, this message translates to:
  /// **'Red Beans'**
  String get ing_redBeans;

  /// No description provided for @ing_whiteOnion.
  ///
  /// In en, this message translates to:
  /// **'White Onion'**
  String get ing_whiteOnion;

  /// No description provided for @ing_jalapeno.
  ///
  /// In en, this message translates to:
  /// **'Jalapeno'**
  String get ing_jalapeno;

  /// No description provided for @section_specials_title.
  ///
  /// In en, this message translates to:
  /// **'3. Choose Your Specials'**
  String get section_specials_title;

  /// No description provided for @section_specials_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose 5 Specials'**
  String get section_specials_subtitle;

  /// No description provided for @section_specials_additionalCost.
  ///
  /// In en, this message translates to:
  /// **'Additional Ingredients cost + 2 SAR'**
  String get section_specials_additionalCost;

  /// No description provided for @ing_broccoli.
  ///
  /// In en, this message translates to:
  /// **'Broccoli'**
  String get ing_broccoli;

  /// No description provided for @ing_greenApple.
  ///
  /// In en, this message translates to:
  /// **'Green Apple'**
  String get ing_greenApple;

  /// No description provided for @ing_potato.
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get ing_potato;

  /// No description provided for @ing_pomegranate.
  ///
  /// In en, this message translates to:
  /// **'Pomegranate'**
  String get ing_pomegranate;

  /// No description provided for @ing_zucchini.
  ///
  /// In en, this message translates to:
  /// **'Zucchini'**
  String get ing_zucchini;

  /// No description provided for @ing_fig.
  ///
  /// In en, this message translates to:
  /// **'Fig'**
  String get ing_fig;

  /// No description provided for @section_cheese_title.
  ///
  /// In en, this message translates to:
  /// **'4. Choose Your Cheese'**
  String get section_cheese_title;

  /// No description provided for @section_cheese_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose 4 Cheese'**
  String get section_cheese_subtitle;

  /// No description provided for @section_cheese_additionalCost.
  ///
  /// In en, this message translates to:
  /// **'Additional Ingredients cost + 2 SAR'**
  String get section_cheese_additionalCost;

  /// No description provided for @ing_feta.
  ///
  /// In en, this message translates to:
  /// **'Feta'**
  String get ing_feta;

  /// No description provided for @ing_parmesan.
  ///
  /// In en, this message translates to:
  /// **'Parmesan'**
  String get ing_parmesan;

  /// No description provided for @ing_cheddar.
  ///
  /// In en, this message translates to:
  /// **'Cheddar'**
  String get ing_cheddar;

  /// No description provided for @section_protein_title.
  ///
  /// In en, this message translates to:
  /// **'5. Choose Your Protein'**
  String get section_protein_title;

  /// No description provided for @section_protein_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Pick 1 Protein'**
  String get section_protein_subtitle;

  /// No description provided for @ing_grilledChicken.
  ///
  /// In en, this message translates to:
  /// **'Grilled Chicken'**
  String get ing_grilledChicken;

  /// No description provided for @ing_mushrmChicken.
  ///
  /// In en, this message translates to:
  /// **'Mushrm Chicken'**
  String get ing_mushrmChicken;

  /// No description provided for @ing_friedChicken.
  ///
  /// In en, this message translates to:
  /// **'Fried Chicken'**
  String get ing_friedChicken;

  /// No description provided for @ing_crispyChicken.
  ///
  /// In en, this message translates to:
  /// **'Crispy Chicken'**
  String get ing_crispyChicken;

  /// No description provided for @ing_tofu.
  ///
  /// In en, this message translates to:
  /// **'Tofu'**
  String get ing_tofu;

  /// No description provided for @ing_meatBalls.
  ///
  /// In en, this message translates to:
  /// **'Meat Balls'**
  String get ing_meatBalls;

  /// No description provided for @ing_shrimp.
  ///
  /// In en, this message translates to:
  /// **'Shrimp'**
  String get ing_shrimp;

  /// No description provided for @ing_tuna.
  ///
  /// In en, this message translates to:
  /// **'Tuna'**
  String get ing_tuna;

  /// No description provided for @price_plus7Sar.
  ///
  /// In en, this message translates to:
  /// **'+7 SAR'**
  String get price_plus7Sar;

  /// No description provided for @section_dressing_title.
  ///
  /// In en, this message translates to:
  /// **'6. Choose Your Dressing'**
  String get section_dressing_title;

  /// No description provided for @section_dressing_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose 6/7'**
  String get section_dressing_subtitle;

  /// No description provided for @section_dressing_additionalCost.
  ///
  /// In en, this message translates to:
  /// **'Additional Ingredients cost + 2 SAR'**
  String get section_dressing_additionalCost;

  /// No description provided for @ing_otsSauce.
  ///
  /// In en, this message translates to:
  /// **'OTS Sauce'**
  String get ing_otsSauce;

  /// No description provided for @ing_creamyCilantro.
  ///
  /// In en, this message translates to:
  /// **'Creamy Cilantro'**
  String get ing_creamyCilantro;

  /// No description provided for @ing_caesar.
  ///
  /// In en, this message translates to:
  /// **'Caesar'**
  String get ing_caesar;

  /// No description provided for @ing_spicyRanch.
  ///
  /// In en, this message translates to:
  /// **'Spicy Ranch'**
  String get ing_spicyRanch;

  /// No description provided for @ing_thaiSauce.
  ///
  /// In en, this message translates to:
  /// **'Thai Sauce'**
  String get ing_thaiSauce;

  /// No description provided for @ing_spicySauceCilantro.
  ///
  /// In en, this message translates to:
  /// **'Spicy Sauce Cilantro'**
  String get ing_spicySauceCilantro;

  /// No description provided for @ing_balsamic.
  ///
  /// In en, this message translates to:
  /// **'Balsamic'**
  String get ing_balsamic;

  /// No description provided for @ing_beetroot.
  ///
  /// In en, this message translates to:
  /// **'Beetroot'**
  String get ing_beetroot;

  /// No description provided for @ing_tahini.
  ///
  /// In en, this message translates to:
  /// **'Tahini'**
  String get ing_tahini;

  /// No description provided for @section_garnish_title.
  ///
  /// In en, this message translates to:
  /// **'7. Choose Your Garnish'**
  String get section_garnish_title;

  /// No description provided for @section_garnish_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Garnish'**
  String get section_garnish_subtitle;

  /// No description provided for @section_garnish_additionalCost.
  ///
  /// In en, this message translates to:
  /// **'Additional Ingredients cost + 2 SAR'**
  String get section_garnish_additionalCost;

  /// No description provided for @ing_potatoSticks.
  ///
  /// In en, this message translates to:
  /// **'Potato Sticks'**
  String get ing_potatoSticks;

  /// No description provided for @ing_croutons.
  ///
  /// In en, this message translates to:
  /// **'Croutons'**
  String get ing_croutons;

  /// No description provided for @ing_peanuts.
  ///
  /// In en, this message translates to:
  /// **'Peanuts'**
  String get ing_peanuts;

  /// No description provided for @ing_sesame.
  ///
  /// In en, this message translates to:
  /// **'Sesame'**
  String get ing_sesame;

  /// No description provided for @ing_quinoa.
  ///
  /// In en, this message translates to:
  /// **'Quinoa'**
  String get ing_quinoa;

  /// No description provided for @ing_sunflower.
  ///
  /// In en, this message translates to:
  /// **'Sunflower'**
  String get ing_sunflower;

  /// No description provided for @ing_flaxSeed.
  ///
  /// In en, this message translates to:
  /// **'Flax Seed'**
  String get ing_flaxSeed;

  /// No description provided for @ing_pumpkinSeeds.
  ///
  /// In en, this message translates to:
  /// **'Pumpkin Seeds'**
  String get ing_pumpkinSeeds;

  /// No description provided for @ing_nachos.
  ///
  /// In en, this message translates to:
  /// **'Nachos'**
  String get ing_nachos;

  /// No description provided for @categoryCreateYourOwn.
  ///
  /// In en, this message translates to:
  /// **'Create Your Own'**
  String get categoryCreateYourOwn;

  /// No description provided for @categorySalads.
  ///
  /// In en, this message translates to:
  /// **'Salads'**
  String get categorySalads;

  /// No description provided for @categoryWarmBowls.
  ///
  /// In en, this message translates to:
  /// **'Warm Bowls'**
  String get categoryWarmBowls;

  /// No description provided for @categoryWraps.
  ///
  /// In en, this message translates to:
  /// **'Wraps'**
  String get categoryWraps;

  /// No description provided for @macroCarb.
  ///
  /// In en, this message translates to:
  /// **'Carb'**
  String get macroCarb;

  /// No description provided for @macroProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get macroProtein;

  /// No description provided for @macroFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get macroFat;

  /// No description provided for @macroCal.
  ///
  /// In en, this message translates to:
  /// **'Cal'**
  String get macroCal;

  /// No description provided for @customiseThisBowl.
  ///
  /// In en, this message translates to:
  /// **'Customise this Bowl'**
  String get customiseThisBowl;

  /// No description provided for @item_burgerBowl_name.
  ///
  /// In en, this message translates to:
  /// **'Burger Bowl'**
  String get item_burgerBowl_name;

  /// No description provided for @item_burgerBowl_description.
  ///
  /// In en, this message translates to:
  /// **'OTE rice / cauliflower rice, meat balls, cheddar cheese, white onions, cherry tomatoes, pickles, lettuce, potatoes, sesame, OTE sauce'**
  String get item_burgerBowl_description;

  /// No description provided for @item_mediterraneanBowl_name.
  ///
  /// In en, this message translates to:
  /// **'Mediterranean Bowl'**
  String get item_mediterraneanBowl_name;

  /// No description provided for @item_mediterraneanBowl_description.
  ///
  /// In en, this message translates to:
  /// **'Quinoa, grilled chicken, feta cheese, cucumber, cherry tomatoes, olives, red onion, hummus, tzatziki sauce'**
  String get item_mediterraneanBowl_description;

  /// No description provided for @noOrdersHere.
  ///
  /// In en, this message translates to:
  /// **'No orders here.'**
  String get noOrdersHere;

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// No description provided for @reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get reorder;

  /// No description provided for @statusPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get statusPreparing;

  /// No description provided for @statusOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get statusOnTheWay;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @progressOrderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order placed'**
  String get progressOrderPlaced;

  /// No description provided for @progressPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get progressPreparing;

  /// No description provided for @progressOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get progressOnTheWay;

  /// No description provided for @progressDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get progressDelivered;

  /// No description provided for @yourOrders.
  ///
  /// In en, this message translates to:
  /// **'YOUR ORDERS'**
  String get yourOrders;

  /// No description provided for @tabActive.
  ///
  /// In en, this message translates to:
  /// **'Active ({count})'**
  String tabActive(Object count);

  /// No description provided for @tabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabHistory;

  /// No description provided for @order2847Items.
  ///
  /// In en, this message translates to:
  /// **'1x Custom Salad Bowl\n1x Green Goddess'**
  String get order2847Items;

  /// No description provided for @order2847Total.
  ///
  /// In en, this message translates to:
  /// **'80 SR'**
  String get order2847Total;

  /// No description provided for @order2847Status.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get order2847Status;

  /// No description provided for @order2847Eta.
  ///
  /// In en, this message translates to:
  /// **'15 MIN'**
  String get order2847Eta;

  /// No description provided for @order2847Time.
  ///
  /// In en, this message translates to:
  /// **'Today • 2:30 PM'**
  String get order2847Time;

  /// No description provided for @order2846Items.
  ///
  /// In en, this message translates to:
  /// **'2x Power Bowl'**
  String get order2846Items;

  /// No description provided for @order2846Total.
  ///
  /// In en, this message translates to:
  /// **'84 SR'**
  String get order2846Total;

  /// No description provided for @order2846Status.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get order2846Status;

  /// No description provided for @order2846Eta.
  ///
  /// In en, this message translates to:
  /// **'25 MIN'**
  String get order2846Eta;

  /// No description provided for @order2846Time.
  ///
  /// In en, this message translates to:
  /// **'Today • 1:45 PM'**
  String get order2846Time;

  /// No description provided for @order2845Items_0.
  ///
  /// In en, this message translates to:
  /// **'1x Custom Salad Bowl'**
  String get order2845Items_0;

  /// No description provided for @order2845Items_1.
  ///
  /// In en, this message translates to:
  /// **'3x Protein Balls'**
  String get order2845Items_1;

  /// No description provided for @order2845Total.
  ///
  /// In en, this message translates to:
  /// **'67 SR'**
  String get order2845Total;

  /// No description provided for @order2845Date.
  ///
  /// In en, this message translates to:
  /// **'Feb 12, 2026 • 7:20 PM'**
  String get order2845Date;

  /// No description provided for @order2844Items_0.
  ///
  /// In en, this message translates to:
  /// **'1x Green Goddess'**
  String get order2844Items_0;

  /// No description provided for @order2844Total.
  ///
  /// In en, this message translates to:
  /// **'38 SR'**
  String get order2844Total;

  /// No description provided for @order2844Date.
  ///
  /// In en, this message translates to:
  /// **'Feb 11, 2026 • 6:15 PM'**
  String get order2844Date;

  /// No description provided for @stepOrderPlaced_title.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get stepOrderPlaced_title;

  /// No description provided for @stepOrderPlaced_desc.
  ///
  /// In en, this message translates to:
  /// **'Your order has been confirmed'**
  String get stepOrderPlaced_desc;

  /// No description provided for @stepPreparing_title.
  ///
  /// In en, this message translates to:
  /// **'Preparing Your Order'**
  String get stepPreparing_title;

  /// No description provided for @stepPreparing_desc.
  ///
  /// In en, this message translates to:
  /// **'Kitchen is preparing your food'**
  String get stepPreparing_desc;

  /// No description provided for @stepOnTheWay_title.
  ///
  /// In en, this message translates to:
  /// **'On the Way'**
  String get stepOnTheWay_title;

  /// No description provided for @stepOnTheWay_titlePickup.
  ///
  /// In en, this message translates to:
  /// **'Ready for Pickup'**
  String get stepOnTheWay_titlePickup;

  /// No description provided for @stepOnTheWay_descActive.
  ///
  /// In en, this message translates to:
  /// **'Your order is being delivered'**
  String get stepOnTheWay_descActive;

  /// No description provided for @stepOnTheWay_descPickup.
  ///
  /// In en, this message translates to:
  /// **'Your order is ready for pickup'**
  String get stepOnTheWay_descPickup;

  /// No description provided for @stepOnTheWay_descPending.
  ///
  /// In en, this message translates to:
  /// **'Your order will be on its way soon'**
  String get stepOnTheWay_descPending;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'MY ACCOUNT'**
  String get myAccount;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Sarah Ahmed'**
  String get userName;

  /// No description provided for @userEmail.
  ///
  /// In en, this message translates to:
  /// **'sarah.ahmed@email.com'**
  String get userEmail;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since Jan 2026'**
  String get memberSince;

  /// No description provided for @statOrders.
  ///
  /// In en, this message translates to:
  /// **'ORDERS'**
  String get statOrders;

  /// No description provided for @statPoints.
  ///
  /// In en, this message translates to:
  /// **'POINTS'**
  String get statPoints;

  /// No description provided for @statSaved.
  ///
  /// In en, this message translates to:
  /// **'SAVED'**
  String get statSaved;

  /// No description provided for @currentRank.
  ///
  /// In en, this message translates to:
  /// **'CURRENT RANK'**
  String get currentRank;

  /// No description provided for @rankFreshStart.
  ///
  /// In en, this message translates to:
  /// **'Fresh Start'**
  String get rankFreshStart;

  /// No description provided for @pointsToNextRank.
  ///
  /// In en, this message translates to:
  /// **'{count} points to '**
  String pointsToNextRank(Object count);

  /// No description provided for @nextRankName.
  ///
  /// In en, this message translates to:
  /// **'Bowl Regular'**
  String get nextRankName;

  /// No description provided for @aboutMyDating.
  ///
  /// In en, this message translates to:
  /// **'About MyDating'**
  String get aboutMyDating;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn our story, locations & values'**
  String get aboutSubtitle;

  /// No description provided for @menuEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get menuEditProfile;

  /// No description provided for @menuAddresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get menuAddresses;

  /// No description provided for @menuPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get menuPaymentMethods;

  /// No description provided for @menuNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get menuNotifications;

  /// No description provided for @menuFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get menuFavorites;

  /// No description provided for @menuRewardsProgram.
  ///
  /// In en, this message translates to:
  /// **'Rewards Program'**
  String get menuRewardsProgram;

  /// No description provided for @menuBowlPacks.
  ///
  /// In en, this message translates to:
  /// **'Bowl Packs'**
  String get menuBowlPacks;

  /// No description provided for @menuHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get menuHelpSupport;

  /// No description provided for @menuOrderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get menuOrderHistory;

  /// No description provided for @badgeRewardRank.
  ///
  /// In en, this message translates to:
  /// **'Fresh Start'**
  String get badgeRewardRank;

  /// No description provided for @badgeBowlPacks.
  ///
  /// In en, this message translates to:
  /// **'3 Meals'**
  String get badgeBowlPacks;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'MyDating v1.0.0'**
  String get appVersion;

  /// No description provided for @eatWellLevelUp.
  ///
  /// In en, this message translates to:
  /// **'Eat well. Level up.'**
  String get eatWellLevelUp;

  /// No description provided for @pointsBalance.
  ///
  /// In en, this message translates to:
  /// **'POINTS BALANCE'**
  String get pointsBalance;

  /// No description provided for @pointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get pointsLabel;

  /// No description provided for @pointsPerSar.
  ///
  /// In en, this message translates to:
  /// **'{points} points for every 1 SAR you spend. Yes, really.'**
  String pointsPerSar(Object points);

  /// No description provided for @pointsExpiry.
  ///
  /// In en, this message translates to:
  /// **'Points expire May 10, 2026'**
  String get pointsExpiry;

  /// No description provided for @seeYourProgress.
  ///
  /// In en, this message translates to:
  /// **'See your progress'**
  String get seeYourProgress;

  /// No description provided for @yourTiers.
  ///
  /// In en, this message translates to:
  /// **'YOUR TIERS'**
  String get yourTiers;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @tierFreshStart.
  ///
  /// In en, this message translates to:
  /// **'Fresh Start'**
  String get tierFreshStart;

  /// No description provided for @tierBowlRegular.
  ///
  /// In en, this message translates to:
  /// **'Bowl Regular'**
  String get tierBowlRegular;

  /// No description provided for @tierGreenMachine.
  ///
  /// In en, this message translates to:
  /// **'Green\nMachine'**
  String get tierGreenMachine;

  /// No description provided for @tierEarthElite.
  ///
  /// In en, this message translates to:
  /// **'Earth Elite'**
  String get tierEarthElite;

  /// No description provided for @nextUp.
  ///
  /// In en, this message translates to:
  /// **'NEXT UP'**
  String get nextUp;

  /// No description provided for @nextUpTierName.
  ///
  /// In en, this message translates to:
  /// **'Bowl Regular'**
  String get nextUpTierName;

  /// No description provided for @nextUpDescription.
  ///
  /// In en, this message translates to:
  /// **'You\'re 50 points away.'**
  String get nextUpDescription;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'ABOUT US'**
  String get aboutUs;

  /// No description provided for @aboutDesc1.
  ///
  /// In en, this message translates to:
  /// **'We are a Saudi home-grown, healthy-focused restaurant brand that originated in Khobar and expanded to Riyadh (An Nakheel).'**
  String get aboutDesc1;

  /// No description provided for @aboutDesc2.
  ///
  /// In en, this message translates to:
  /// **'We are known as a salad bar, offering customizable bowls with bases like greens or rice, proteins, and specialized sauces. Our menu also includes unique desserts like soft-serve açai, fresh berries, granola, Nutella, and beverages such as iced coffee and matcha.'**
  String get aboutDesc2;

  /// No description provided for @whatMakesUsSpecial.
  ///
  /// In en, this message translates to:
  /// **'WHAT MAKES US SPECIAL'**
  String get whatMakesUsSpecial;

  /// No description provided for @specialBetterForYou_title.
  ///
  /// In en, this message translates to:
  /// **'Better For You'**
  String get specialBetterForYou_title;

  /// No description provided for @specialBetterForYou_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fresh, organic ingredients sourced locally'**
  String get specialBetterForYou_subtitle;

  /// No description provided for @specialSustainable_title.
  ///
  /// In en, this message translates to:
  /// **'Sustainable'**
  String get specialSustainable_title;

  /// No description provided for @specialSustainable_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Eco-friendly packaging and practices'**
  String get specialSustainable_subtitle;

  /// No description provided for @specialSaudiHomegrown_title.
  ///
  /// In en, this message translates to:
  /// **'Saudi Homegrown'**
  String get specialSaudiHomegrown_title;

  /// No description provided for @specialSaudiHomegrown_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Proudly originated in Khobar, KSA'**
  String get specialSaudiHomegrown_subtitle;

  /// No description provided for @ourConcept.
  ///
  /// In en, this message translates to:
  /// **'OUR CONCEPT'**
  String get ourConcept;

  /// No description provided for @conceptCustomBowls_title.
  ///
  /// In en, this message translates to:
  /// **'Custom Bowls'**
  String get conceptCustomBowls_title;

  /// No description provided for @conceptCustomBowls_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your own mix with various bases, proteins, and sauces'**
  String get conceptCustomBowls_subtitle;

  /// No description provided for @conceptSignatureSalads_title.
  ///
  /// In en, this message translates to:
  /// **'Signature Salads'**
  String get conceptSignatureSalads_title;

  /// No description provided for @conceptSignatureSalads_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Includes options like Crab Salad and various poultry-based salads with signature OTE sauce'**
  String get conceptSignatureSalads_subtitle;

  /// No description provided for @conceptSpecialtyItems_title.
  ///
  /// In en, this message translates to:
  /// **'Specialty Items'**
  String get conceptSpecialtyItems_title;

  /// No description provided for @conceptSpecialtyItems_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Soft-serve açai, berries, granola, and unique beverages'**
  String get conceptSpecialtyItems_subtitle;

  /// No description provided for @ourLocations.
  ///
  /// In en, this message translates to:
  /// **'OUR LOCATIONS'**
  String get ourLocations;

  /// No description provided for @locationRiyadh_city.
  ///
  /// In en, this message translates to:
  /// **'Riyadh'**
  String get locationRiyadh_city;

  /// No description provided for @locationRiyadh_area.
  ///
  /// In en, this message translates to:
  /// **'An Nakheel'**
  String get locationRiyadh_area;

  /// No description provided for @locationRiyadh_hours.
  ///
  /// In en, this message translates to:
  /// **'Sun-Sat 11am-1am, Fri 2pm-1am'**
  String get locationRiyadh_hours;

  /// No description provided for @locationKhobar_city.
  ///
  /// In en, this message translates to:
  /// **'Khobar'**
  String get locationKhobar_city;

  /// No description provided for @locationKhobar_area.
  ///
  /// In en, this message translates to:
  /// **'Ar Rakah Al Janubiyah'**
  String get locationKhobar_area;

  /// No description provided for @locationKhobar_hours.
  ///
  /// In en, this message translates to:
  /// **'Daily 11am-1am'**
  String get locationKhobar_hours;

  /// No description provided for @locationAlKhobar_city.
  ///
  /// In en, this message translates to:
  /// **'Al Khobar'**
  String get locationAlKhobar_city;

  /// No description provided for @locationAlKhobar_area.
  ///
  /// In en, this message translates to:
  /// **'Al Jisr'**
  String get locationAlKhobar_area;

  /// No description provided for @locationAlKhobar_hours.
  ///
  /// In en, this message translates to:
  /// **'Daily 11am-1am'**
  String get locationAlKhobar_hours;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'A \"better for you\" fast-casual dining experience offering healthy, customizable bowls and nutritious snacks.'**
  String get tagline;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @locations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locations;

  /// No description provided for @addressHome1_label.
  ///
  /// In en, this message translates to:
  /// **'Home 1'**
  String get addressHome1_label;

  /// No description provided for @addressHome1_address.
  ///
  /// In en, this message translates to:
  /// **'Villa 7, Prince Sultan Road, Al Salamah District'**
  String get addressHome1_address;

  /// No description provided for @addressBuilding18_label.
  ///
  /// In en, this message translates to:
  /// **'Building 18'**
  String get addressBuilding18_label;

  /// No description provided for @addressBuilding18_address.
  ///
  /// In en, this message translates to:
  /// **'Building 18, Floor 3, King Saud Street, Al Faisaliyah District'**
  String get addressBuilding18_address;

  /// No description provided for @addressWork_label.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get addressWork_label;

  /// No description provided for @addressWork_address.
  ///
  /// In en, this message translates to:
  /// **'Building 214, Apartment 12, King Fahd Road, Al Olaya District'**
  String get addressWork_address;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @myFav.
  ///
  /// In en, this message translates to:
  /// **'My Fav'**
  String get myFav;

  /// No description provided for @myFavDesc.
  ///
  /// In en, this message translates to:
  /// **'My Fav'**
  String get myFavDesc;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @removeCard.
  ///
  /// In en, this message translates to:
  /// **'Remove card?'**
  String get removeCard;

  /// No description provided for @removeCardConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {type} ending in {last4}?'**
  String removeCardConfirm(Object last4, Object type);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @addPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Add Payment Method'**
  String get addPaymentMethod;

  /// No description provided for @editCard.
  ///
  /// In en, this message translates to:
  /// **'Edit Card'**
  String get editCard;

  /// No description provided for @cardType.
  ///
  /// In en, this message translates to:
  /// **'Card type (e.g. VISA)'**
  String get cardType;

  /// No description provided for @last4Digits.
  ///
  /// In en, this message translates to:
  /// **'Last 4 digits'**
  String get last4Digits;

  /// No description provided for @expiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry (MM/YY)'**
  String get expiry;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get addCard;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @defaultCard.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultCard;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @offersTitle.
  ///
  /// In en, this message translates to:
  /// **'MyDating Offers'**
  String get offersTitle;

  /// No description provided for @offersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get special offers, promos and personalised suggestions'**
  String get offersSubtitle;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTitle;

  /// No description provided for @ordersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real-time updates about your orders and delivery status.'**
  String get ordersSubtitle;

  /// No description provided for @orderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderStatus;

  /// No description provided for @rewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rewards and Points'**
  String get rewardsTitle;

  /// No description provided for @rewardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your rewards, points and achievements.'**
  String get rewardsSubtitle;

  /// No description provided for @badgeEarned.
  ///
  /// In en, this message translates to:
  /// **'Badge earned'**
  String get badgeEarned;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet.'**
  String get noFavoritesYet;

  /// No description provided for @bowlPacks.
  ///
  /// In en, this message translates to:
  /// **'BOWL PACKS'**
  String get bowlPacks;

  /// No description provided for @bowlPacksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay stocked. Stay fresh.'**
  String get bowlPacksSubtitle;

  /// No description provided for @bowlsWaitingCount.
  ///
  /// In en, this message translates to:
  /// **'You\'ve got {count} bowls waiting.'**
  String bowlsWaitingCount(Object count);

  /// No description provided for @seeYourBowlHistory.
  ///
  /// In en, this message translates to:
  /// **'See your bowl history'**
  String get seeYourBowlHistory;

  /// No description provided for @communityFavorite.
  ///
  /// In en, this message translates to:
  /// **'COMMUNITY FAVORITE'**
  String get communityFavorite;

  /// No description provided for @pack5Title.
  ///
  /// In en, this message translates to:
  /// **'5 Bowl Pack'**
  String get pack5Title;

  /// No description provided for @pack5Price.
  ///
  /// In en, this message translates to:
  /// **'100 SR'**
  String get pack5Price;

  /// No description provided for @pack5Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Perfect for the week.'**
  String get pack5Subtitle;

  /// No description provided for @pack5Note.
  ///
  /// In en, this message translates to:
  /// **'Use within 30 days.'**
  String get pack5Note;

  /// No description provided for @pack5Button.
  ///
  /// In en, this message translates to:
  /// **'Grab this pack'**
  String get pack5Button;

  /// No description provided for @pack10Title.
  ///
  /// In en, this message translates to:
  /// **'10 Bowl Pack'**
  String get pack10Title;

  /// No description provided for @pack10Price.
  ///
  /// In en, this message translates to:
  /// **'200 SR'**
  String get pack10Price;

  /// No description provided for @pack10Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Most ordered.'**
  String get pack10Subtitle;

  /// No description provided for @pack10Note.
  ///
  /// In en, this message translates to:
  /// **'Use within 45 days.'**
  String get pack10Note;

  /// No description provided for @pack10Button.
  ///
  /// In en, this message translates to:
  /// **'Let\'s do 10'**
  String get pack10Button;

  /// No description provided for @pack30Title.
  ///
  /// In en, this message translates to:
  /// **'30 Bowl Pack'**
  String get pack30Title;

  /// No description provided for @pack30Price.
  ///
  /// In en, this message translates to:
  /// **'500 SR'**
  String get pack30Price;

  /// No description provided for @pack30Subtitle.
  ///
  /// In en, this message translates to:
  /// **'For the fully committed.'**
  String get pack30Subtitle;

  /// No description provided for @pack30Note.
  ///
  /// In en, this message translates to:
  /// **'Use within 60 days.'**
  String get pack30Note;

  /// No description provided for @pack30Button.
  ///
  /// In en, this message translates to:
  /// **'Go all in'**
  String get pack30Button;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// No description provided for @liveChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with our support team'**
  String get liveChatSubtitle;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get callUs;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupport;

  /// No description provided for @emailSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'support@mydating.com'**
  String get emailSupportSubtitle;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @faqsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find answers to common questions'**
  String get faqsSubtitle;

  /// No description provided for @supportHours.
  ///
  /// In en, this message translates to:
  /// **'Support Hours'**
  String get supportHours;

  /// No description provided for @monFri.
  ///
  /// In en, this message translates to:
  /// **'Monday - Friday'**
  String get monFri;

  /// No description provided for @monFriHours.
  ///
  /// In en, this message translates to:
  /// **'9:00 AM - 10:00 PM'**
  String get monFriHours;

  /// No description provided for @satSun.
  ///
  /// In en, this message translates to:
  /// **'Saturday - Sunday'**
  String get satSun;

  /// No description provided for @satSunHours.
  ///
  /// In en, this message translates to:
  /// **'10:00 AM - 8:00 PM'**
  String get satSunHours;

  /// No description provided for @bowls_left_two.
  ///
  /// In en, this message translates to:
  /// **'2 bowls left'**
  String get bowls_left_two;

  /// No description provided for @bowls_left_one.
  ///
  /// In en, this message translates to:
  /// **'1 bowl left'**
  String get bowls_left_one;

  /// No description provided for @from_pack.
  ///
  /// In en, this message translates to:
  /// **'From your 5-bowl pack'**
  String get from_pack;

  /// No description provided for @use_by_dec_12.
  ///
  /// In en, this message translates to:
  /// **'Use by Dec 12'**
  String get use_by_dec_12;

  /// No description provided for @use_by_dec_30.
  ///
  /// In en, this message translates to:
  /// **'Use by Dec 30'**
  String get use_by_dec_30;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @order_number.
  ///
  /// In en, this message translates to:
  /// **'Order #{orderNumber}'**
  String order_number(Object orderNumber);

  /// No description provided for @delivering_in.
  ///
  /// In en, this message translates to:
  /// **'Delivering in {eta}'**
  String delivering_in(Object eta);

  /// No description provided for @order_from.
  ///
  /// In en, this message translates to:
  /// **'Order From'**
  String get order_from;

  /// No description provided for @delivering_to.
  ///
  /// In en, this message translates to:
  /// **'Delivering to'**
  String get delivering_to;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @subscription_meals.
  ///
  /// In en, this message translates to:
  /// **'Subscription Meals x{count}'**
  String subscription_meals(Object count);

  /// No description provided for @points_redeemed.
  ///
  /// In en, this message translates to:
  /// **'Points Redeemed ({points})'**
  String points_redeemed(Object points);

  /// No description provided for @vat_percent.
  ///
  /// In en, this message translates to:
  /// **'VAT ({percent}%)'**
  String vat_percent(Object percent);

  /// No description provided for @delivery_fee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get delivery_fee;

  /// No description provided for @currency_sar.
  ///
  /// In en, this message translates to:
  /// **'{amount} SR'**
  String currency_sar(Object amount);

  /// No description provided for @order_status_on_the_way.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get order_status_on_the_way;

  /// No description provided for @time_format.
  ///
  /// In en, this message translates to:
  /// **'{day}, {date} · {time}'**
  String time_format(Object date, Object day, Object time);

  /// No description provided for @item_burger_bowl.
  ///
  /// In en, this message translates to:
  /// **'Burger Bowl x{count}'**
  String item_burger_bowl(Object count);

  /// No description provided for @item_make_your_own.
  ///
  /// In en, this message translates to:
  /// **'Make Your Own'**
  String get item_make_your_own;

  /// No description provided for @item_description.
  ///
  /// In en, this message translates to:
  /// **'OTE rice / meat balls, cheddar cheese, white onions, cherry tomatoes, pickles, lettuce, potatoes, sesame, OTE sauce'**
  String get item_description;

  /// No description provided for @selectOrderType.
  ///
  /// In en, this message translates to:
  /// **'Select Order Type'**
  String get selectOrderType;

  /// No description provided for @orderType.
  ///
  /// In en, this message translates to:
  /// **'Order Type'**
  String get orderType;

  /// No description provided for @oteRewardsHistory.
  ///
  /// In en, this message translates to:
  /// **'OTE Rewards History'**
  String get oteRewardsHistory;

  /// No description provided for @allTiers.
  ///
  /// In en, this message translates to:
  /// **'All Tiers'**
  String get allTiers;

  /// No description provided for @selectThisLocation.
  ///
  /// In en, this message translates to:
  /// **'Select This Location'**
  String get selectThisLocation;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Selected Location'**
  String get selectedLocation;

  /// No description provided for @searchPlaces.
  ///
  /// In en, this message translates to:
  /// **'Search places…'**
  String get searchPlaces;

  /// No description provided for @locatingYou.
  ///
  /// In en, this message translates to:
  /// **'Locating you…'**
  String get locatingYou;

  /// No description provided for @earned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get earned;

  /// No description provided for @redeemed.
  ///
  /// In en, this message translates to:
  /// **'Redeemed'**
  String get redeemed;

  /// No description provided for @purchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get purchased;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get used;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @noAddressesYet.
  ///
  /// In en, this message translates to:
  /// **'No addresses yet.'**
  String get noAddressesYet;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @enterFullNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterFullNameError;

  /// No description provided for @enterMobileNumberError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get enterMobileNumberError;

  /// No description provided for @enterDateOfBirthError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your date of birth'**
  String get enterDateOfBirthError;

  /// No description provided for @enterNationalIdError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your national Id'**
  String get enterNationalIdError;

  /// No description provided for @emailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailError;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @attachImage.
  ///
  /// In en, this message translates to:
  /// **'Attach Image'**
  String get attachImage;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @wereHereToHelp.
  ///
  /// In en, this message translates to:
  /// **'We’re here to help. Tell us what you need and our team will get back to you shortly.'**
  String get wereHereToHelp;

  /// No description provided for @supportFormSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Support form submitted successfully'**
  String get supportFormSubmittedSuccessfully;

  /// No description provided for @validAddressError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid address'**
  String get validAddressError;

  /// No description provided for @validMessageError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid message'**
  String get validMessageError;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @areYouSureYouWantToDeleteYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get areYouSureYouWantToDeleteYourAccount;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @userDifferentMobile.
  ///
  /// In en, this message translates to:
  /// **'Use different mobile'**
  String get userDifferentMobile;

  /// No description provided for @mobileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Mobile updated successfully'**
  String get mobileUpdatedSuccessfully;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available'**
  String get noDescription;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessfully;

  /// No description provided for @enterValidNationalId.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid national ID'**
  String get enterValidNationalId;

  /// No description provided for @noItemFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemFound;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @quickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get quickAdd;

  /// No description provided for @editPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Edit Phone Number'**
  String get editPhoneNumber;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @earthElite.
  ///
  /// In en, this message translates to:
  /// **'Earth Elite'**
  String get earthElite;

  /// No description provided for @greenMachine.
  ///
  /// In en, this message translates to:
  /// **'Green Machine'**
  String get greenMachine;

  /// No description provided for @bowlRegular.
  ///
  /// In en, this message translates to:
  /// **'Bowl Regular'**
  String get bowlRegular;

  /// No description provided for @freshStart.
  ///
  /// In en, this message translates to:
  /// **'Fresh Start'**
  String get freshStart;

  /// No description provided for @may232026.
  ///
  /// In en, this message translates to:
  /// **'May 23, 2026'**
  String get may232026;

  /// No description provided for @april92026.
  ///
  /// In en, this message translates to:
  /// **'April 9, 2026'**
  String get april92026;

  /// No description provided for @march152026.
  ///
  /// In en, this message translates to:
  /// **'March 15, 2026'**
  String get march152026;

  /// No description provided for @feb102026.
  ///
  /// In en, this message translates to:
  /// **'Feb 10, 2026'**
  String get feb102026;

  /// No description provided for @currentAchievement.
  ///
  /// In en, this message translates to:
  /// **'CURRENT ACHIEVEMENT'**
  String get currentAchievement;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get from;

  /// No description provided for @pleaseSelectAddress.
  ///
  /// In en, this message translates to:
  /// **'Please select delivery address'**
  String get pleaseSelectAddress;

  /// No description provided for @pleaseSelectBranch.
  ///
  /// In en, this message translates to:
  /// **'Please select a branch'**
  String get pleaseSelectBranch;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @branchArea.
  ///
  /// In en, this message translates to:
  /// **'Branch Area'**
  String get branchArea;

  /// No description provided for @branchAddress.
  ///
  /// In en, this message translates to:
  /// **'Branch Address'**
  String get branchAddress;

  /// No description provided for @pleaseEnterAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter an address title'**
  String get pleaseEnterAddressTitle;

  /// No description provided for @deleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddress;

  /// No description provided for @areYouSureYouWantToDeleteYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your address?'**
  String get areYouSureYouWantToDeleteYourAddress;

  /// No description provided for @back_to_orders.
  ///
  /// In en, this message translates to:
  /// **'Back to Orders'**
  String get back_to_orders;

  /// No description provided for @pointsHistory.
  ///
  /// In en, this message translates to:
  /// **'Points History'**
  String get pointsHistory;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @clear_all.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clear_all;

  /// No description provided for @no_notifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get no_notifications;

  /// No description provided for @no_order_notifications.
  ///
  /// In en, this message translates to:
  /// **'No order notifications'**
  String get no_order_notifications;

  /// No description provided for @no_reward_notifications.
  ///
  /// In en, this message translates to:
  /// **'No reward notifications'**
  String get no_reward_notifications;

  /// No description provided for @cropImage.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get cropImage;

  /// No description provided for @noPointHistory.
  ///
  /// In en, this message translates to:
  /// **'No point history yet'**
  String get noPointHistory;

  /// No description provided for @noPointHistoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Your point transactions will appear here once you start earning or spending points.'**
  String get noPointHistoryDescription;

  /// No description provided for @noActiveOrdersDescription.
  ///
  /// In en, this message translates to:
  /// **'Your active orders will appear here once you place an order.'**
  String get noActiveOrdersDescription;

  /// No description provided for @emptyCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCartTitle;

  /// No description provided for @noOrderHistoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Your past orders will appear here once you have completed an order.'**
  String get noOrderHistoryDescription;

  /// No description provided for @emptyCartDescription.
  ///
  /// In en, this message translates to:
  /// **'Add some delicious bowls to start ordering!'**
  String get emptyCartDescription;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @noItemsFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'There are no items to display right now.'**
  String get noItemsFoundDescription;

  /// No description provided for @pointsShort.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String pointsShort(Object points);

  /// No description provided for @nutritionFacts.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Facts'**
  String get nutritionFacts;

  /// No description provided for @allergens.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get allergens;

  /// No description provided for @customizeItem.
  ///
  /// In en, this message translates to:
  /// **'Customize Item'**
  String get customizeItem;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @explore_menu.
  ///
  /// In en, this message translates to:
  /// **'Explore Menu'**
  String get explore_menu;

  /// No description provided for @pleaseSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Please Select Location'**
  String get pleaseSelectLocation;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @areYouSureYouWantToLogOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get areYouSureYouWantToLogOut;

  /// No description provided for @removeItem.
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get removeItem;

  /// No description provided for @areYouSureYouWantToRemoveThisItem.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this item from your cart?'**
  String get areYouSureYouWantToRemoveThisItem;

  /// No description provided for @emptyAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'No Saved Addresses'**
  String get emptyAddressTitle;

  /// No description provided for @emptyAddressDescription.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any addresses yet. Add an address to make checkout faster and easier.'**
  String get emptyAddressDescription;

  /// No description provided for @chooseYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Choose your Address'**
  String get chooseYourAddress;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @customize.
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get customize;

  /// No description provided for @addressTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Address Title (e.g. Home, Work)'**
  String get addressTitleHint;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgainToExit;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @makePaymentForOrder.
  ///
  /// In en, this message translates to:
  /// **'Pay for Order'**
  String get makePaymentForOrder;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @maxRankReached.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the top rank!'**
  String get maxRankReached;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @failed_to_load_branches.
  ///
  /// In en, this message translates to:
  /// **'Failed to load branches'**
  String get failed_to_load_branches;

  /// No description provided for @delivery_not_available.
  ///
  /// In en, this message translates to:
  /// **'Delivery not available'**
  String get delivery_not_available;

  /// No description provided for @no_branch_nearby.
  ///
  /// In en, this message translates to:
  /// **'no branch nearby please choose diffrent address'**
  String get no_branch_nearby;

  /// No description provided for @branch_closed_or_busy.
  ///
  /// In en, this message translates to:
  /// **'branch closed or busy'**
  String get branch_closed_or_busy;

  /// No description provided for @branch_currently_closed.
  ///
  /// In en, this message translates to:
  /// **'Sorry, this branch is currently closed'**
  String get branch_currently_closed;

  /// No description provided for @branch_currently_busy.
  ///
  /// In en, this message translates to:
  /// **'Sorry, this branch is currently busy, please try again shortly'**
  String get branch_currently_busy;

  /// No description provided for @order_type_not_available.
  ///
  /// In en, this message translates to:
  /// **'This order type is not available for the selected branch'**
  String get order_type_not_available;

  /// No description provided for @item_out_of_stock.
  ///
  /// In en, this message translates to:
  /// **'Item {itemName} is out of stock'**
  String item_out_of_stock(Object itemName);

  /// No description provided for @please_select_delivery_location.
  ///
  /// In en, this message translates to:
  /// **'Please select delivery location'**
  String get please_select_delivery_location;

  /// No description provided for @failed_to_create_payment_link.
  ///
  /// In en, this message translates to:
  /// **'Failed to create payment link'**
  String get failed_to_create_payment_link;

  /// No description provided for @payment_not_completed.
  ///
  /// In en, this message translates to:
  /// **'Payment was not completed'**
  String get payment_not_completed;

  /// No description provided for @no_address_specified.
  ///
  /// In en, this message translates to:
  /// **'No Address Specified'**
  String get no_address_specified;

  /// No description provided for @failed_to_validate_cart.
  ///
  /// In en, this message translates to:
  /// **'Failed to validate cart'**
  String get failed_to_validate_cart;

  /// No description provided for @pickup_from_branch.
  ///
  /// In en, this message translates to:
  /// **'Pickup from Branch'**
  String get pickup_from_branch;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @pleaseSelectGender.
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get pleaseSelectGender;

  /// No description provided for @orderNotes.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get orderNotes;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  String get genderCannotBeChangedNote;
  String get selectYourGender;
  String get selectGenderSubtitle;
  String get continueButton;
  String get onboardingTitle1;
  String get onboardingDesc1;
  String get onboardingTitle2;
  String get onboardingDesc2;
  String get onboardingTitle3;
  String get onboardingDesc3;
  String get skip;
  String get next;
  String get getStarted;
  String get chatContactSharingBlocked;
  String get signingInWithGoogle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
