import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/core/localization/changeLocale.dart';
import 'package:guidy/core/localization/myDictionary.dart';
import 'package:guidy/core/services/sharedPreferences.dart';
import 'package:guidy/routes.dart';
import 'core/functions/restarter.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAaZP-mmxrggthz8SQ2I2jwnB6YiPyvpGA",
      appId: "1:767444906402:android:f78f3aeb2a648a921282fb",
      messagingSenderId: '767444906402',
      projectId: "guidy-a691d",
    ),

  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        splitScreenMode: true,
        designSize: const Size(412, 892),
        minTextAdapt: true);
    LocaleController localeController = Get.put(LocaleController());
    return ScreenUtilInit(
      designSize: const Size(412, 892),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: false,
      child: RestartWidget(
        child: GetMaterialApp(
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaleFactor: 1, size: const Size(412, 892)),
                child: child!);
          },
          title: "Guidy",
          debugShowCheckedModeBanner: false,
          theme: localeController.appTheme,
          translations: MyDictionary(),
          locale: localeController.language,
          getPages: pages,
        ),
      ),
    );
  }
}