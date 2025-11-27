import 'package:map_app/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFFFF8A65), // Soft coral-orange
  brightness: Brightness.light,
  background: const Color(0xFFFBEAF3), // Light blush/pink background
  surface: Colors.white.withOpacity(0.2), // for glass effect
);


final theme = ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,
  scaffoldBackgroundColor: colorScheme.background,
  fontFamily: GoogleFonts.ubuntu().fontFamily,
  textTheme: GoogleFonts.ubuntuTextTheme().copyWith(
    titleLarge: GoogleFonts.ubuntu(
      fontWeight: FontWeight.bold,
      fontSize: 22,
      color: Colors.black87,
    ),
  ),
);


void main() {
  runApp(
     ProviderScope(child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(  
      
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Great Places',
        theme: theme,
        home: Startscreen(),
      ),
    );
  }
}