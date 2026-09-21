import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vetmark/app/routes.dart';
import 'package:vetmark/app/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushNamed(context, AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: .circular(28),
                ),
                child: const Center(
                  child: Text('🐾', style: TextStyle(fontSize: 58)),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'VetMark',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: .bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cuidado de quem faz parte da família',
                textAlign: .center,
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 48),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
