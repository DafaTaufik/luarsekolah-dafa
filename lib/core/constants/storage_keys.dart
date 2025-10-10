/// Storage keys constants for SharedPreferences
/// Class, contains all the keys used for local storage.
///
class StorageKeys {
  // Private constructor to prevent instantiation
  StorageKeys._();

  // ==================== Authentication ====================
  static const String isLoggedIn = 'is_logged_in';
  static const String authToken = 'auth_token';

  // ==================== User Data ====================
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String userPhone = 'user_phone';
  static const String userId = 'user_id';
  static const String userPassword = 'user_password';

  // ==================== Profile Data ====================
  static const String userPhoto = 'user_photo';
  static const String userBirthDate = 'user_birth_date';
  static const String userAddress = 'user_address';
  static const String userGender = 'user_gender';
  static const String userJobStatus = 'user_job_status';

  // ==================== App Settings ====================
  static const String notificationEnabled = 'notification_enabled';
}
