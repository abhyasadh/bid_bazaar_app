import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import '../routes/app_routes.dart';

final navigationServiceProvider = Provider<NavigationServiceProvider>((ref) {
  return NavigationServiceProvider();
});

class NavigationServiceProvider {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo({String? routeName, Widget? page, Object? arguments, PageTransitionType transitionType = PageTransitionType.rightToLeft}) {
    return navigatorKey.currentState!.push(
      PageTransition(
        type: transitionType,
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        child: routeName!=null ? _getPage(routeName, arguments) : page!,
        settings: RouteSettings(name: routeName, arguments: arguments),
      ),
    );
  }

  Future<dynamic> replaceWith({String? routeName, Widget? page, Object? arguments, PageTransitionType transitionType = PageTransitionType.rightToLeft}) {
    return navigatorKey.currentState!.pushReplacement(
      PageTransition(
        type: transitionType,
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        child: routeName!=null ? _getPage(routeName, arguments) : page!,
        settings: RouteSettings(name: routeName, arguments: arguments),
      ),
    );
  }

  void popUntil(String routeName) {
    navigatorKey.currentState!.popUntil((route) {
      return route.settings.name == routeName;
    });
  }

  void goBack() {
    navigatorKey.currentState!.pop();
  }

  Widget _getPage(String routeName, Object? arguments) {
    final routes = AppRoutes.getApplicationRoute();
    WidgetBuilder? builder = routes[routeName];
    if (builder != null) {
      return builder(navigatorKey.currentContext!);
    }
    return const NotFoundPage();
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: const Center(
        child: Text('404 - Page Not Found'),
      ),
    );
  }
}
