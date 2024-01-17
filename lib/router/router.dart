import 'package:delivery_app/auth/signin/views/signin_page.dart';
import 'package:delivery_app/auth/views/splash_page.dart';
import 'package:delivery_app/home/views/home_page.dart';
import 'package:go_router/go_router.dart';

class RouterBuilder {
  static GoRouter buildRouter() {
    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: SplashPage.route.path,
      routes: [
        SplashPage.route,
        SigninPage.route,
        HomePage.route,
      ],
    );
  }
}
