import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'viewmodels/providers.dart';
import 'views/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const KimeshiApp(),
    ),
  );
}

class KimeshiApp extends StatelessWidget {
  const KimeshiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kimeshi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFE65100), // 深いオレンジ
          onPrimary: Colors.white,
          secondary: Color(0xFF558B2F), // 新鮮なグリーン
          onSecondary: Colors.white,
          tertiary: Color(0xFFFFB74D), // 明るいオレンジ
          onTertiary: Color(0xFF3E2723),
          error: Color(0xFFD32F2F),
          onError: Colors.white,
          surface: Color(0xFFFFF8E1), // クリーム色の背景
          onSurface: Color(0xFF3E2723), // ダークブラウン
          surfaceContainerHighest: Color(0xFFFFECB3),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8E1),
        useMaterial3: true,
        fontFamily: 'Hiragino Sans',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE65100),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE65100),
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
