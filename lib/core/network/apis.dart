class AppApis{
  static const String baseUrl='https://shart.dev01.matrix-clouds.com/api/';
//User
  //Auth
  static const String loginUser='${baseUrl}user/login';
  static const String registerUser='${baseUrl}user/register';
  static const String verifyAccountUser='${baseUrl}user/verify_account';
  static const String sendOTPUser='${baseUrl}user/send-otp';
  //Profile
  static const String getProfileUser='${baseUrl}user/profile';
  static const String updateProfileUser='${baseUrl}user/update-profile';
  static const String deleteAccount='${baseUrl}user/delete-account';
  //Company
  static const String termsAndConditionUser='${baseUrl}pages/terms_and_conditions';
  static const String privacyAndPolicyUser='${baseUrl}pages/privacy_policy';






//Provider
  //Auth
  static const String loginProvider='${baseUrl}provider/login';
  static const String  registerProvider='${baseUrl}provider/register';
  static const String verifyAccountProvider='${baseUrl}provider/verify_account';
  static const String sendOTPProvider='${baseUrl}provider/send-otp';
  //profile
  static const String getProviderProfileUser='${baseUrl}provider/profile';
  static const String updateProviderProfileUser='${baseUrl}provider/update-profile';
  static const String deleteAccountProvider='${baseUrl}provider/delete-account';
  static const String getAddressProvider='${baseUrl}provider/addresses';
  static const String addAddressProvider='${baseUrl}provider/addresses/add';
  static  String editAddressProvider (int id)=>'${baseUrl}provider/addresses/edit/$id';
  static  String deleteAddressProvider (int id)=>'${baseUrl}provider/addresses/delete/$id';
//Pages
  static const String termsAndConditionProvider='${baseUrl}provider/pages/terms_and_conditions_provider_app';
  static const String privacyAndPolicyProvider='${baseUrl}provider/pages/privacy_policy_provider_app';
  static const String aboutCompany='${baseUrl}pages/about';


//Package Check
  static const String checkCars='${baseUrl}packages';
  static const String brands='${baseUrl}brands';
  static String brandModel(int id)=> '${baseUrl}modals/$id';
  static const String brandColors='${baseUrl}colors';

}