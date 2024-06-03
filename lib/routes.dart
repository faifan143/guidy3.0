import 'package:get/get.dart';
import 'package:guidy/core/constants/AppRoutes.dart';
import 'package:guidy/core/middleware/myMiddleware.dart';
import 'package:guidy/view/screens/Language.dart';
import 'package:guidy/view/screens/auth/login.dart';
import 'package:guidy/view/screens/auth/signup.dart';
import 'package:guidy/view/screens/main_screen.dart';

import 'package:guidy/view/screens/main-screens/extras/search_screen.dart';
import 'package:guidy/view/screens/onBoarding.dart';

List<GetPage<dynamic>>? pages = [
  // onBoarding
  GetPage(
    name: "/",
    page: () => const Language(),
    middlewares: [MyOnBoardingMiddleware(), MyLoginMiddleware()],
  ),
  // OnBoarding
  GetPage(name: AppRoutes.onBoarding, page: () => const OnBoarding()),
  // Auth
  GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
  GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),
  // App Screens
  GetPage(name: AppRoutes.mainScreen, page: () => const MainScreen()),

  GetPage(name: AppRoutes.searchScreen, page: () => const SearchScreen()),
];


