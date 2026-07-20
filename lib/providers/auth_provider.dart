import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _apiService.login(username, password);
      
      if (result['success']) {
        // Load user profile
        await _loadUserProfile();
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> _loadUserProfile() async {
    try {
      final response = await _apiService.get('users/profile/');
      _user = User.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> logout() async {
    await _apiService.clearTokens();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
  
  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _apiService.register(userData);
      
      if (result['success']) {
        // Auto login after registration
        return await login(userData['username'], userData['password']);
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> checkAuthStatus() async {
    await _apiService.loadTokens();
    // Check if token exists and is valid
    // If valid, load user profile
  }
}