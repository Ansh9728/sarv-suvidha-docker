import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kpa_erp/firebase_options.dart';
import 'package:kpa_erp/models/auth_model.dart';
import 'package:kpa_erp/models/user_model.dart';
import 'package:kpa_erp/provider/auth_provider.dart';
import 'package:kpa_erp/provider/cheek_sheet_provider.dart';
import 'package:kpa_erp/provider/icf_wheel_provider.dart';
import 'package:kpa_erp/route_logger.dart';
import 'package:kpa_erp/routes.dart';
import 'package:kpa_erp/screens/Home_screen/check_sheet_form.dart';
import 'package:kpa_erp/screens/Home_screen/home_screen.dart';
import 'package:kpa_erp/screens/Home_screen/icf_wheel.dart';
import 'package:kpa_erp/screens/splash_screen.dart';
import 'package:kpa_erp/user_screen/forgot_password_screen.dart';
import 'package:kpa_erp/user_screen/login_mobile_screen.dart';
import 'package:kpa_erp/user_screen/login_screen.dart';
import 'package:kpa_erp/user_screen/mobile_otp_screen.dart';
import 'package:kpa_erp/user_screen/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? lastRoute = prefs.getString('lastRoute') ?? Routes.splashScreen;

  runApp(MainApp(initialRoute: lastRoute));
}

class MainApp extends StatelessWidget {
  final String initialRoute;

  const MainApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    RouteLogger routes = RouteLogger();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthModel()),
        ChangeNotifierProvider(create: (_) => UserModel()),
        ChangeNotifierProvider(create: (_) => IcfWheelProvider()),
        ChangeNotifierProvider(create: (_) => ChecksheetFormProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sanchalak',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        ),
        navigatorObservers: [routes],
        initialRoute: Routes.splashScreen,
        routes: {
          Routes.login: (context) => LoginScreen(),
          Routes.home: (context) => HomeScreen(),
          Routes.splashScreen: (context) => const SplashScreen(),
          Routes.signUp: (context) => const SignUpScreen(),
          Routes.wheelSpecForm: (context) => const IcfWheel(),
          Routes.bogieChecksheetForm: (context) => const ChecksheetFormScreen(),
          Routes.forgotPassword: (context) => const ForgotPasswordScreen(),
          Routes.mobileLogin: (context) => const LoginMobileScreen(),
          Routes.otpEnter: (context) => const MobileOtpScreen(),
        },
      ),
    );
  }
}
