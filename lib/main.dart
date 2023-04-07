import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:multi_store_app/auth/customer_signup.dart';
import 'package:multi_store_app/auth/supplier_login.dart';
import 'package:multi_store_app/auth/supplier_signup.dart';
import 'package:multi_store_app/main_screens/customer_home_screen.dart';
import 'package:multi_store_app/main_screens/supplier_home.dart';

import 'auth/customer_login.dart';
import 'main_screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/welcome_screen",
        routes: {
          "/welcome_screen": (context) => const WelcomeScreen(),
          "/customer_home": (context) => const CustomerHomeScreen(),
          "/supplier_home": (context) => const SupplierHomeScreen(),
          "/customer_signup": (context) => const CustomerRegister(),
          "/customer_login": (context) => const CustomerLogin(),
          "/supplier_signup": (context) => const SupplierRegister(),
          "/supplier_login": (context) => const SupplierLogin(),
        },
      ),
    );
  }
}
