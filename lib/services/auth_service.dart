import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userPhone;
  String? _userName;

  bool get isAuthenticated => _isAuthenticated;
  String? get userPhone => _userPhone;
  String? get userName => _userName;

  Future<bool> login(String phone, String password) async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    
    // TODO: Remplacer par une vraie logique d'authentification
    // Pour l'instant, on accepte n'importe quel numéro de téléphone/mot de passe
    _isAuthenticated = true;
    _userPhone = phone;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String phone, String password) async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    
    // TODO: Remplacer par une vraie logique d'enregistrement
    _isAuthenticated = true;
    _userName = name;
    _userPhone = phone;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userPhone = null;
    _userName = null;
    notifyListeners();
  }
}

