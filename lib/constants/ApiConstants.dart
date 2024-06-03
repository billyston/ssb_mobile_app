class ApiConstants{
  static String baseUrl = 'https://mobile.thesusubox.com/v1/mobile/';

  static String numberVerification = 'customers/registrations/verifications';
  static String sendOTP = 'customers/registrations/tokens';
  static String customers = 'customers/';
  static String verifyOTP = '/registrations/tokens/verifications';
  static String createPersonalInfo = '/registrations/personal-information';
  static String createEmailAndPassword = '/registrations/passwords';
  static String createPin = '/pins';

  static String loginCustomer = 'customers/authentications/logins';

  static String resetPasswordVerifyNumber = 'customers/passwords/resets/requests';
  static String resetPasswordVerifyOTP = '/passwords/resets/tokens/verifications';
  static String resetPassword = '/passwords/resets';

  static String getNetworkSchemes = 'customers/linked-accounts/schemes';
  static String getLinkedAccounts = 'customers/linked-accounts';
  static String linkAccount = 'customers/linked-accounts/';
  static String approvals = '/approvals';

  static String susuSchemes = 'customers/susus/schemes';
  static String getAllSusu = 'customers/susus';

  static String createPersonalSusu = 'customers/susus/personal-susus/creations';
  static String approvePersonalSusu = 'customers/susus/personal-susus/';

  static String createBizSusu = 'customers/susus/biz-susus/creations';
  static String approveBizSusu = 'customers/susus/biz-susus/';

  static String createGoalGetterSusu = 'customers/susus/goal-getter-susus/creations';
  static String approveGoalGetterSusu = 'customers/susus/goal-getter-susus/';

  static String createFlexySusu = 'customers/susus/flexy-susus/creations';
  static String approveFlexySusu = 'customers/susus/flexy-susus/';

  static String getPersonalSusu = 'customers/susus/personal-susus/';
  static String getBizSusu = 'customers/susus/biz-susus/';
  static String getGoalGetterSusu = 'customers/susus/goal-getter-susus/';
  static String getFlexySusu = 'customers/susus/flexy-susus/';

  static String getBalance = 'customers/susus/';

  static String getTransactionHistory = 'customers/susus/';



}