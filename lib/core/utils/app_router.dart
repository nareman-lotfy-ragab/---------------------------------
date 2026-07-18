import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/main_navigation/presentation/pages/main_navigation_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/crop_recommendations/presentation/pages/crop_recommendations_page.dart';
import '../../features/farm_mapping/presentation/pages/farm_mapping_page.dart';
import '../../features/ai_chat/presentation/pages/ai_chat_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/plant_disease/presentation/pages/plant_disease_page.dart';
import '../../features/community/presentation/pages/community_page.dart';
import '../../features/treatments/presentation/pages/my_treatments_page.dart';
import '../../features/home/presentation/pages/my_fields_page.dart';
import '../../features/home/presentation/pages/add_field_page.dart';
import '../../features/home/presentation/pages/field_details_page.dart';
import '../../features/home/data/models/field_model.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  static final _shellNavigatorCropsKey = GlobalKey<NavigatorState>(debugLabel: 'crops');
  static final _shellNavigatorMappingKey = GlobalKey<NavigatorState>(debugLabel: 'mapping');
  static final _shellNavigatorChatKey = GlobalKey<NavigatorState>(debugLabel: 'chat');
  static final _shellNavigatorCommunityKey = GlobalKey<NavigatorState>(debugLabel: 'community');
  static final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

  static final router = GoRouter(
    initialLocation: '/splash',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'plant-disease',
                    builder: (context, state) => const PlantDiseasePage(),
                  ),
                  GoRoute(
                    path: 'my-treatments',
                    builder: (context, state) => const MyTreatmentsPage(),
                  ),
                  GoRoute(
                    path: 'my-fields',
                    builder: (context, state) => const MyFieldsPage(),
                    routes: [
                      GoRoute(
                        path: 'add',
                        builder: (context, state) => const AddFieldPage(),
                      ),
                      GoRoute(
                        path: 'details',
                        builder: (context, state) {
                          final field = state.extra as FieldModel;
                          return FieldDetailsPage(field: field);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorCropsKey,
            routes: [
              GoRoute(
                path: '/crops',
                builder: (context, state) => const CropRecommendationsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMappingKey,
            routes: [
              GoRoute(
                path: '/mapping',
                builder: (context, state) => const FarmMappingPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorChatKey,
            routes: [
              GoRoute(
                path: '/chat',
                builder: (context, state) => const AIChatPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorCommunityKey,
            routes: [
              GoRoute(
                path: '/community',
                builder: (context, state) => const CommunityPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
