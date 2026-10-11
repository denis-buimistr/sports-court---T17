import 'package:go_router/go_router.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/booking/booking_confirm_screen.dart';
import 'screens/booking/time_slot_screen.dart';
import 'screens/courts/court_details_screen.dart';
import 'screens/courts/courts_list_screen.dart';
import 'screens/my_bookings/my_bookings_screen.dart';
import 'screens/profile/profile_edit_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'widgets/app_shell.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    // auth stays outside the shell: no tabs here
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/courts',
              builder: (context, state) => const CourtsListScreen(),
              routes: [
                // fixed segments go before ':id'
                GoRoute(
                  path: ':id',
                  builder: (context, state) =>
                      CourtDetailsScreen(courtId: state.pathParameters['id']!),
                  routes: [
                    GoRoute(
                      path: 'slots',
                      builder: (context, state) =>
                          TimeSlotScreen(courtId: state.pathParameters['id']!),
                    ),
                    GoRoute(
                      path: 'slots/:slotId/confirm',
                      builder: (context, state) => BookingConfirmScreen(
                        courtId: state.pathParameters['id']!,
                        slotId: state.pathParameters['slotId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/bookings',
              builder: (context, state) => const MyBookingsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => const ProfileEditScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);