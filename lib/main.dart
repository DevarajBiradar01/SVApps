import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svapp/authentication/mentor/view_models/mentor_login_vm.dart';
import 'package:svapp/common/view_models/view_pdf_vm.dart';
import 'package:svapp/mentor/view_models/add_pdf_vm.dart';
import 'package:svapp/mentor/view_models/add_test_vm.dart';
import 'package:svapp/splash/views/splash_screen.dart';
import 'package:svapp/theme/constants.dart';
import 'package:svapp/user/view_models/exam_desc_vm.dart';
import 'package:svapp/user/view_models/test_screen_vm.dart';
import 'package:svapp/user/view_models/user_drawer_vm.dart';
import 'package:svapp/user/view_models/user_home_vm.dart';

import 'authentication/aspirant/view_models/personal_info_vm.dart';
import 'authentication/aspirant/view_models/phone_auth_vm.dart';
import 'authentication/aspirant/view_models/sign_in_vm.dart';
import 'authentication/aspirant/view_models/sign_up_vm.dart';
import 'common/view_models/view_video_vm.dart';
import 'mentor/view_models/add_video_vm.dart';
import 'mentor/view_models/categories_vm.dart';
import 'mentor/view_models/mentor_home_vm.dart';
import 'mentor/view_models/sub_categories_vm.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: []);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ///Aspirant Authentication
        ChangeNotifierProvider<SignInVM>(create: (_) => SignInVM()),
        ChangeNotifierProvider<SignUpVM>(create: (_) => SignUpVM()),
        ChangeNotifierProvider<PhoneAuthVM>(create: (_) => PhoneAuthVM()),
        ChangeNotifierProvider<PersonalInfoVM>(create: (_) => PersonalInfoVM()),

        ///Mentor Auth
        ChangeNotifierProvider<MentorLoginVm>(create: (_) => MentorLoginVm()),

        ///Mentor Home
        ChangeNotifierProvider<MentorHomeVM>(create: (_) => MentorHomeVM()),
        ChangeNotifierProvider<CategoriesVM>(create: (_) => CategoriesVM()),
        ChangeNotifierProvider<SubCategoriesVM>(
            create: (_) => SubCategoriesVM()),
        ChangeNotifierProvider<AddTestVM>(create: (_) => AddTestVM()),
        ChangeNotifierProvider<ExamDescVM>(create: (_) => ExamDescVM()),
        ChangeNotifierProvider<TestScreenVM>(create: (_) => TestScreenVM()),
        ChangeNotifierProvider<UserHomeVM>(create: (_) => UserHomeVM()),
        ChangeNotifierProvider<UserDrawerVM>(create: (_) => UserDrawerVM()),
        ChangeNotifierProvider<AddPdfVM>(create: (_) => AddPdfVM()),
        ChangeNotifierProvider<ViewPdfVM>(create: ((_) => ViewPdfVM())),
        ChangeNotifierProvider<AddVideoVm>(create: (_) => AddVideoVm()),
        ChangeNotifierProvider<ViewVideoVM>(create: (_) => ViewVideoVM())
      ],
      child: MaterialApp(
        title: 'SV Exams',
        //themeMode: ThemeMode.dark,
        darkTheme: ThemeData(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          primarySwatch: primaryColor,
          iconTheme: const IconThemeData(color: iconColor, size: 25),
          fontFamily: GoogleFonts.aBeeZee().fontFamily,
          textTheme: const TextTheme(
            bodyLarge:
                TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.w500),
            bodyMedium:
                TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.w400),
            bodySmall: TextStyle(letterSpacing: 1.5),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: primaryTextFieldFillColor,
            filled: true,
            hoverColor: primaryTextFieldBorderColor,
            focusColor: primaryTextFieldFocusColor,
            hintStyle: const TextStyle(letterSpacing: 1.2),
            labelStyle: const TextStyle(letterSpacing: 1.2),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: primaryTextFieldBorderColor),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        home: const SplashScreenView(),
      ),
    );
  }
}
