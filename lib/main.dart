import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picroper/config/app_colors.dart';
import 'package:picroper/config/app_text_styles.dart';
import 'package:picroper/features/home/home_screen.dart';
import 'package:picroper/features/resize/resize_screen.dart';
import 'package:picroper/features/validation/validation_screen.dart';
import 'package:picroper/features/confirmation/confirmation_screen.dart'; // Import ConfirmationScreen

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/resize',
      name: 'resize',
      builder: (BuildContext context, GoRouterState state) {
        final Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;
        final String imagePath = extra!['imagePath'] as String;
        final double? widthCm = extra['widthCm'] as double?;
        final double? heightCm = extra['heightCm'] as double?;
        return ResizeScreen(
          imagePath: imagePath,
          initialWidthCm: widthCm,
          initialHeightCm: heightCm,
        );
      },
    ),
    GoRoute(
      path: '/validation',
      name: 'validation',
      builder: (BuildContext context, GoRouterState state) {
        final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return ValidationScreen(
          imagePath: args['imagePath'] as String,
          widthCm: args['widthCm'] as double,
          heightCm: args['heightCm'] as double,
        );
      },
    ),
    GoRoute(
      path: '/confirmation',
      name: 'confirmation',
      builder: (BuildContext context, GoRouterState state) {
        final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return ConfirmationScreen(
          orderNumber: args['orderNumber'] as String,
          imagePath: args['imagePath'] as String?,
          format: args['format'] as String,
          support: args['support'] as String,
          frame: args['frame'] as String,
          quantity: args['quantity'] as int,
          totalAmount: args['totalAmount'] as double,
        );
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Picroper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.primaryLight,
          onSecondary: AppColors.onSecondary,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          background: AppColors.background,
          onBackground: AppColors.onBackground,
          error: AppColors.error,
          onError: AppColors.onError,
        ),
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: AppTextStyles.headline1,
          displayMedium: AppTextStyles.headline2,
          bodyLarge: AppTextStyles.bodyText1,
          bodyMedium: AppTextStyles.bodyText2,
          labelLarge: AppTextStyles.button,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.onPrimary,
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: AppTextStyles.button,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}