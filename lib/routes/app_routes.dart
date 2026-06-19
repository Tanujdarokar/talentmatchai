import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/pipeline/pipeline_screen.dart';
import '../screens/analytics/analytics_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/search/ai_search_screen.dart';
import '../screens/ranking/ai_questions_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/settings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String pipeline = '/pipeline';
  static const String analytics = '/analytics';
  static const String notifications = '/notifications';
  static const String reports = '/reports';
  static const String search = '/search';
  static const String aiQuestions = '/ai-questions';
  static const String editProfile = '/edit-profile';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    home: (context) => const MainNavigationScreen(),
    pipeline: (context) => const PipelineScreen(),
    analytics: (context) => const AnalyticsScreen(),
    notifications: (context) => const NotificationsScreen(),
    reports: (context) => const ReportsScreen(),
    search: (context) => const AiSearchScreen(),
    aiQuestions: (context) => const AiQuestionsScreen(),
    editProfile: (context) => const EditProfileScreen(),
  };
}
