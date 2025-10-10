import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

/// Service for managing local storage using SharedPreferences
///
/// Provides methods to save, retrieve, and clear user data.

class LocalStorageService {
  // Singleton pattern
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  // ==================== User Data Management ====================

  static Future<bool> saveUserData({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(StorageKeys.userName, name);
      await prefs.setString(StorageKeys.userEmail, email);
      await prefs.setString(StorageKeys.userPhone, phone);
      await prefs.setString(StorageKeys.userPassword, password);
      await prefs.setBool(StorageKeys.isLoggedIn, true);

      return true;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  /// Get all user data as a Map
  /// Returns null values if data doesn't exist
  static Future<Map<String, String?>> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return {
        'name': prefs.getString(StorageKeys.userName),
        'email': prefs.getString(StorageKeys.userEmail),
        'phone': prefs.getString(StorageKeys.userPhone),
        'password': prefs.getString(StorageKeys.userPassword),
      };
    } catch (e) {
      print('Error getting user data: $e');
      return {'name': null, 'email': null, 'phone': null};
    }
  }

  /// Get user's name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.userName);
  }

  /// Get user email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.userEmail);
  }

  /// Get user phone number
  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.userPhone);
  }

  /// Get user password
  static Future<String?> getUserPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.userPassword);
  }

  /// Get user job status
  static Future<String?> getUserJobStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.userJobStatus);
  }

  // ==================== Authentication Management ====================

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(StorageKeys.isLoggedIn) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  /// Set login status
  static Future<bool> setLoginStatus(bool isLoggedIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(StorageKeys.isLoggedIn, isLoggedIn);
    } catch (e) {
      print('Error setting login status: $e');
      return false;
    }
  }

  // ==================== Profile Management ====================

  /// Save user profile photo URL
  static Future<bool> saveUserPhoto(String photoUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(StorageKeys.userPhoto, photoUrl);
    } catch (e) {
      print('Error saving user photo: $e');
      return false;
    }
  }

  /// Get user profile photo URL
  static Future<String?> getUserPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.userPhoto);
  }

  /// Update user profile data
  static Future<bool> updateUserProfile({
    String? name,
    String? email,
    String? phone,
    String? birthDate,
    String? address,
    String? gender,
    String? jobStatus,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (name != null) await prefs.setString(StorageKeys.userName, name);
      if (email != null) await prefs.setString(StorageKeys.userEmail, email);
      if (phone != null) await prefs.setString(StorageKeys.userPhone, phone);
      if (birthDate != null)
        await prefs.setString(StorageKeys.userBirthDate, birthDate);
      if (address != null)
        await prefs.setString(StorageKeys.userAddress, address);
      if (gender != null) await prefs.setString(StorageKeys.userGender, gender);
      if (jobStatus != null)
        await prefs.setString(StorageKeys.userJobStatus, jobStatus);

      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // ==================== Logout & Clear Data ====================

  /// Logout user and clear all stored data
  // static Future<bool> logout() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.clear(); // Clear all data
  //     return true;
  //   } catch (e) {
  //     print('Error during logout: $e');
  //     return false;
  //   }
  // }

  /// Clear specific user data only (keep settings)
  static Future<bool> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(StorageKeys.userName);
      await prefs.remove(StorageKeys.userEmail);
      await prefs.remove(StorageKeys.userPhone);
      await prefs.remove(StorageKeys.userId);
      await prefs.remove(StorageKeys.userPhoto);
      await prefs.remove(StorageKeys.userBirthDate);
      await prefs.remove(StorageKeys.userAddress);
      await prefs.remove(StorageKeys.userGender);
      await prefs.remove(StorageKeys.userJobStatus);
      await prefs.remove(StorageKeys.isLoggedIn);
      await prefs.remove(StorageKeys.authToken);

      return true;
    } catch (e) {
      print('Error clearing user data: $e');
      return false;
    }
  }
}
