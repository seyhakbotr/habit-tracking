import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/custom_profile_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/custom_sign_in_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/presentation/entries_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/domain/entry.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/domain/habit.dart'; // Changed from 'jobs' to 'habits'
import 'package:starter_architecture_flutter_firebase/src/features/entries/presentation/entry_screen/entry_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/presentation/dashboard/dashboards_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/presentation/habit_entries_screen/habit_entries_screen.dart'; // Changed from 'job' to 'habit'
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/presentation/edit_habit_screen/edit_habit_screen.dart'; // Changed from 'job' to 'habit'
import 'package:starter_architecture_flutter_firebase/src/features/habits/presentation/habit_screens/habits_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/onboarding/data/onboarding_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/go_router_refresh_stream.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/not_found_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/scaffold_with_nested_navigation.dart';

part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _dashboardNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'dashboard'); // New navigator key for dashboard
final _habitsNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'habits'); // Changed from 'jobs' to 'habits'
final _entriesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'entries');
final _accountNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'account');

enum AppRoute {
  onboarding,
  signIn,
  dashboard, // Added new route for the dashboard
  habits, // Changed from 'jobs' to 'habits'
  habit, // Changed from 'job' to 'habit'
  addHabit, // Changed from 'addJob' to 'addHabit'
  editHabit, // Changed from 'editJob' to 'editHabit'
  entry,
  addEntry,
  editEntry,
  entries,
  profile,
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/signIn',
    navigatorKey: _rootNavigatorKey,
    //debugLogDiagnostics: true,
    redirect: (context, state) {
      final onboardingRepository =
          ref.read(onboardingRepositoryProvider).requireValue;
      final didCompleteOnboarding = onboardingRepository.isOnboardingComplete();
      final path = state.uri.path;
      if (!didCompleteOnboarding) {
        // Always check state.subloc before returning a non-null route
        // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart#L78
        if (path != '/onboarding') {
          return '/onboarding';
        }
        return null;
      }
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        // Redirect to dashboard after sign-in
        if (path.startsWith('/onboarding') || path.startsWith('/signIn')) {
          return '/dashboard'; // Changed to redirect to the new dashboard
        }
      } else {
        if (path.startsWith('/onboarding') ||
            path.startsWith('/dashboard') || // New dashboard route added here
            path.startsWith('/habits') || // Changed from 'jobs' to 'habits'
            path.startsWith('/entries') ||
            path.startsWith('/account')) {
          return '/signIn';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CustomSignInScreen(),
        ),
      ),
      // Stateful navigation based on:
      // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => NoTransitionPage(
          child: ScaffoldWithNestedNavigation(navigationShell: navigationShell),
        ),
        branches: [
          // New branch for the Dashboard
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: '/dashboard',
                name: AppRoute.dashboard.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashboardsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey:
                _habitsNavigatorKey, // Changed from 'jobs' to 'habits'
            routes: [
              GoRoute(
                path: '/habits', // Changed from 'jobs' to 'habits'
                name: AppRoute.habits.name, // Changed from 'jobs' to 'habits'
                pageBuilder: (context, state) => const NoTransitionPage(
                  child:
                      HabitsScreen(), // Changed from 'JobsScreen' to 'HabitsScreen'
                ),
                routes: [
                  GoRoute(
                    path: 'add',
                    name: AppRoute
                        .addHabit.name, // Changed from 'addJob' to 'addHabit'
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) {
                      return const MaterialPage(
                        fullscreenDialog: true,
                        child:
                            EditHabitScreen(), // Changed from 'EditJobScreen' to 'EditHabitScreen'
                      );
                    },
                  ),
                  GoRoute(
                    path: ':id',
                    name: AppRoute.habit.name, // Changed from 'job' to 'habit'
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return MaterialPage(
                        child: HabitEntriesScreen(
                            habitId:
                                id), // Changed from 'JobEntriesScreen' to 'HabitEntriesScreen'
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'entries/add',
                        name: AppRoute.addEntry.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        pageBuilder: (context, state) {
                          final habitId = state.pathParameters['id']!;
                          return MaterialPage(
                            fullscreenDialog: true,
                            child: EntryScreen(
                              habitID: habitId,
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'entries/:eid',
                        name: AppRoute.entry.name,
                        pageBuilder: (context, state) {
                          final habitId = state.pathParameters['id']!;
                          final entryId = state.pathParameters['eid']!;
                          final entry = state.extra as Entry?;
                          return MaterialPage(
                            child: EntryScreen(
                              habitID: habitId,
                              entryId: entryId,
                              entry: entry,
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'edit',
                        name: AppRoute.editHabit
                            .name, // Changed from 'editJob' to 'editHabit'
                        pageBuilder: (context, state) {
                          final habitId = state.pathParameters['id'];
                          final habit = state.extra
                              as Habit?; // Changed from 'Job' to 'Habit'
                          return MaterialPage(
                            fullscreenDialog: true,
                            child: EditHabitScreen(
                                habitId: habitId,
                                habit:
                                    habit), // Changed from 'EditJobScreen' to 'EditHabitScreen' and 'jobId' to 'habitId' and 'job' to 'habit'
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _entriesNavigatorKey,
            routes: [
              GoRoute(
                path: '/entries',
                name: AppRoute.entries.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: EntriesScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _accountNavigatorKey,
            routes: [
              GoRoute(
                path: '/account',
                name: AppRoute.profile.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CustomProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundScreen(),
    ),
  );
}
