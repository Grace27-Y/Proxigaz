import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/auth_service.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  final AuthService authService;

  const AuthPage({super.key, required this.authService});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  
  bool _isLogin = true; // Mode connexion par défaut
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isWhatsAppHovered = false;

  @override
  void initState() {
    super.initState();
    // Pré-remplir avec l'indicatif par défaut
    _phoneController.text = '+225';
    _phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: _phoneController.text.length),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
      // Réinitialiser le champ téléphone avec l'indicatif par défaut
      _phoneController.text = '+225';
      _phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneController.text.length),
      );
    });
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        bool success;
        if (_isLogin) {
          // Mode connexion
          success = await widget.authService.login(
            _phoneController.text,
            _passwordController.text,
          );
        } else {
          // Mode inscription
          success = await widget.authService.register(
            _nameController.text,
            _phoneController.text,
            _passwordController.text,
          );
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (success) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isLogin ? 'Connexion réussie !' : 'Inscription réussie !',
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(milliseconds: 500),
                ),
              );
              
              await Future.delayed(const Duration(milliseconds: 100));
              
              if (mounted) {
                try {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(authService: widget.authService),
                    ),
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  debugPrint('Erreur navigation rootNavigator: $e');
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(authService: widget.authService),
                    ),
                    (Route<dynamic> route) => false,
                  );
                }
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isLogin 
                    ? 'Erreur lors de la connexion'
                    : 'Erreur lors de l\'inscription',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleWhatsAppLogin() async {
    // TODO: Implémenter la connexion WhatsApp
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connexion WhatsApp à venir'),
      ),
    );
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty || value.trim() == '+225') {
      return 'Veuillez entrer votre numéro de téléphone';
    }
    // Vérifier que ça commence par + et qu'il y a au moins un indicatif
    if (!value.startsWith('+')) {
      return 'Le numéro doit commencer par + suivi de l\'indicatif';
    }
    // Vérifier qu'il y a au moins l'indicatif + quelques chiffres
    if (value.length < 6) {
      return 'Format invalide. Indiquez l\'indicatif et le numéro';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre mot de passe';
    }
    if (!_isLogin && value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (!_isLogin) {
      if (value == null || value.isEmpty) {
        return 'Veuillez confirmer votre mot de passe';
      }
      if (value != _passwordController.text) {
        return 'Les mots de passe ne correspondent pas';
      }
    }
    return null;
  }

  String? _validateName(String? value) {
    if (!_isLogin) {
      if (value == null || value.isEmpty) {
        return 'Veuillez entrer votre nom complet';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header orange avec logo
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 232, 90, 20),
                  // Optionnel: Ajouter une image de fond si vous en avez une
                  // image: DecorationImage(
                  //   image: AssetImage('assets/images/background.jpg'),
                  //   fit: BoxFit.cover,
                  //   colorFilter: ColorFilter.mode(
                  //     Colors.orange.withOpacity(0.8),
                  //     BlendMode.darken,
                  //   ),
                  // ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 232, 90, 20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo blanc avec bordure arrondie
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.local_gas_station,
                            size: 50,
                            color: const Color.fromARGB(255, 232, 90, 20),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Texte PROXI'GAS
                        const Text(
                          "PROXI'GAS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Section blanche avec formulaire
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 32),
                        // Champ nom complet (seulement pour l'inscription)
                        if (!_isLogin) ...[
                          const Text(
                            'Nom complet',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Votre nom complet',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(Icons.person_outline, color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: _validateName,
                          ),
                          const SizedBox(height: 24),
                        ],
                        // Champ numéro de téléphone
                        const Text(
                          'Numéro de téléphone',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[\d\s\+]')),
                          ],
                          decoration: InputDecoration(
                            hintText: 'XX XX XX XX XX',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.phone, color: Colors.grey[400]),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: _validatePhone,
                          onChanged: (value) {
                            // S'assurer que le numéro commence toujours par +
                            if (value.isNotEmpty && !value.startsWith('+')) {
                              _phoneController.value = TextEditingValue(
                                text: '+$value',
                                selection: TextSelection.collapsed(offset: value.length + 1),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        // Champ mot de passe
                        const Text(
                          'Mot de passe',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: '........',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: _validatePassword,
                        ),
                        // Champ confirmation mot de passe (seulement pour l'inscription)
                        if (!_isLogin) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'Confirmer le mot de passe',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              hintText: '........',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey[400],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: _validateConfirmPassword,
                          ),
                        ],
                        const SizedBox(height: 8),
                        // Lien mot de passe oublié (seulement pour la connexion)
                        if (_isLogin)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // TODO: Implémenter la récupération de mot de passe
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fonctionnalité à venir'),
                                  ),
                                );
                              },
                              child: const Text(
                                'Mot de passe oublié ?',
                                style: TextStyle(
                                  color:  Color.fromARGB(255, 232, 90, 20),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        // Bouton Se connecter / S'inscrire
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 232, 90, 20),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  _isLogin ? 'Se connecter' : 'S\'inscrire',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),
                        // Lien pour basculer entre connexion et inscription
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isLogin
                                  ? 'Vous n\'avez pas de compte ? '
                                  : 'Vous avez déjà un compte ? ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: _toggleMode,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                _isLogin ? 'S\'inscrire' : 'Se connecter',
                                style: const TextStyle(
                                  color:  Color.fromARGB(255, 232, 90, 20),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Séparateur "Ou"
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey[300],
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Ou',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey[300],
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Bouton WhatsApp
                        MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              _isWhatsAppHovered = true;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              _isWhatsAppHovered = false;
                            });
                          },
                          child: OutlinedButton(
                            onPressed: _handleWhatsAppLogin,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: _isWhatsAppHovered ? Colors.transparent : Colors.green,
                                width: _isWhatsAppHovered ? 0 : 1.5,
                              ),
                              backgroundColor: _isWhatsAppHovered ? Colors.green : Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  color: _isWhatsAppHovered ? Colors.white :  Color.fromARGB(255, 10, 125, 14),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Continuer avec WhatsApp',
                                  style: TextStyle(
                                    color: _isWhatsAppHovered ? Colors.white : Color.fromARGB(255, 10, 125, 14),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
