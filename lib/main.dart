import 'package:flutter/material.dart';
import 'auth_page.dart';
import 'home_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProxiGas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 232, 90, 20),
          primary: const Color.fromARGB(255, 232, 90, 20),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    // Forcer immédiatement un rebuild
    if (mounted) {
      // Utiliser SchedulerBinding pour s'assurer que setState est appelé au bon moment
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
      // Aussi appeler setState immédiatement
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_authService.isAuthenticated) {
      return HomePage(authService: _authService);
    } else {
      return AuthPage(authService: _authService);
    }
  }
}
