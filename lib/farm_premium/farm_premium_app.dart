import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/Access/ProfilePage.dart';
import 'package:jaguza_app/farm_premium/Access/SignInPage.dart';
import 'package:jaguza_app/farm_premium/Animals/AnimalsListPage.dart';
import 'package:jaguza_app/farm_premium/Contacts/ContactsPage.dart';
import 'package:jaguza_app/farm_premium/FarmRequests/FarmRequestsPage.dart';
import 'package:jaguza_app/farm_premium/Feeds/FeedsPage.dart';
import 'package:jaguza_app/farm_premium/Financial/FinancialPage.dart';
import 'package:jaguza_app/farm_premium/Groups/GroupsListPage.dart';
import 'package:jaguza_app/farm_premium/Milk/MilkingHomePage.dart';
import 'package:jaguza_app/farm_premium/Paddocks/PaddocksListPage.dart';
import 'package:jaguza_app/farm_premium/Splash/SplashPage.dart';
import 'package:jaguza_app/farm_premium/Tasks/TasksPage.dart';
import 'package:jaguza_app/farm_premium/Treatment/TreatmentPage.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';

/// Entry point of the JaguzaPremium farm-management module (formerly the
/// standalone JaguzaFarm-Flutter app). It runs inside its own [Navigator] so
/// the module's named routes ('/animals', '/financial', ...) do not leak into
/// the Jaguza app's root routes, and applies the module's own theme.
///
/// Back from the module's first screen returns to the Jaguza app.
class FarmPremiumApp extends StatefulWidget {
  const FarmPremiumApp({super.key});

  @override
  State<FarmPremiumApp> createState() => _FarmPremiumAppState();
}

class _FarmPremiumAppState extends State<FarmPremiumApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  static final _routes = <String, WidgetBuilder>{
    '/treatment': (_) => TreatmentPage(),
    '/financial': (_) => FinancialPage(),
    '/paddocks': (_) => PaddocksListPage(),
    '/groups': (_) => GroupsListPage(),
    '/feeds': (_) => Feedspage(),
    '/animals': (_) => AnimalsListPage(),
    '/profile': (_) => ProfilePage(),
    '/login': (_) => SignInPage(),
    '/farm-requests': (_) => FarmRequestsPage(),
    '/milking-home': (_) => MilkingHomePage(),
    '/tasks': (_) => TasksPage(),
    '/contacts': (_) => ContactsPage(),
    // logoutPerson() navigates to '/home' and clears the stack.
    '/home': (_) => SplashPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          secondary: secondaryColor,
          surface: bgColor,
        ),
        useMaterial3: true,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          final nav = _navigatorKey.currentState!;
          if (await nav.maybePop()) return;
          if (context.mounted) Navigator.of(context).pop();
        },
        child: Navigator(
          key: _navigatorKey,
          onGenerateInitialRoutes: (_, __) => [
            MaterialPageRoute(builder: (_) => SplashPage()),
          ],
          onGenerateRoute: (settings) {
            final builder = _routes[settings.name];
            if (builder == null) return null;
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        ),
      ),
    );
  }
}
