import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:book_now_demo/screens/splash_screen.dart';
import 'package:book_now_demo/shared/cubit/floor_states/my_floor_cubit.dart';
import 'package:book_now_demo/shared/cubit/houses_states/my_house_cubit.dart';
import 'package:book_now_demo/shared/cubit/people_states/my_people_cubit.dart';
import 'package:book_now_demo/shared/cubit/projects_states/my_project_cubit.dart';
import 'package:book_now_demo/shared/cubit/rooms_states/rooms_cubit.dart';
import 'package:book_now_demo/shared/cubit/travel_states/my_travel_cubit.dart';
import 'package:book_now_demo/shared/services/firebase_messages/projects_message.dart';
import 'package:book_now_demo/shared/services/firebase_messages/room_messages.dart';
import 'package:book_now_demo/shared/services/font_services.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:tbib_style/style/font_style.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'shared/bloc_observer.dart';
import 'shared/network/dio_network.dart';
import 'shared/services/alert_google_services.dart';
import 'shared/services/firebase_messages/house_messages.dart';
import 'shared/services/firebase_messages/people_message.dart';
import 'shared/services/firebase_messages/travel_messages.dart';
import 'shared/services/internet_connection/check_internet.dart';
import 'shared/services/firebase_services.dart';
import 'shared/style/main_style.dart';
import 'shared/util/device_screen.dart';
import 'package:wakelock/wakelock.dart';

Future<void> backgroundFirebaseMessagesHandler(RemoteMessage message) async {
  exit(0);
}

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    DeviceType();
    if (!DeviceType.isLargeScreen()) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }
    fontsServices();
    await CheckInternet.init();
    await GoogleServesesChecker.init();
    await FirebaseInit.firebaseServices(
        GoogleServesesChecker.getPlaSytoreAvailability,
        CheckInternet.isConnected);
    DioHelper();
    if (GoogleServesesChecker.getPlaSytoreAvailability ==
            GooglePlayServicesAvailability.success &&
        CheckInternet.isConnected &&
        FirebaseInit.token != null) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      await FirebaseMessaging.instance.subscribeToTopic("all_users");
    }
    await initializeDateFormatting();
    BlocOverrides.runZoned(
      () {
        runApp(const MyApp());
      },
      blocObserver: MyBlocObserver(),
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map? mapMessage;
      mapMessage = json.decode(message.data['listen']);
      if (mapMessage != null) {
        if (mapMessage['messages'].toString().isNotEmpty) {
          log(mapMessage['messages']);
          switch (mapMessage['messages']) {
            case 'Project Created':
              createProjectMessage();
              break;
            case 'House Created':
              {
                createHouseMessages();
                break;
              }
            case 'Floor Updated':
              updateHouseMessages(mapMessage['id']);
              break;
            case 'Room Created':
              createRoomMessages();
              break;
            case 'Room Updated':
              updateRoomMessages(mapMessage['id']);
              break;

            case 'People Created':
              createPeopleMessages();
              break;
            case 'People Updated':
              updatePeopleMessages(mapMessage['id']);
              break;

            case 'Travel Created':
              createTravelMessages();
              break;
            case 'Travel Updated':
              updateTravelMessages(mapMessage['id']);
              break;
          }
        } else {
          log("message empty");
        }
      } else {
        log("message issue firebase");
      }
    });
    FirebaseMessaging.onBackgroundMessage(backgroundFirebaseMessagesHandler);
  }, (error, stackTrace) {
    if (GoogleServesesChecker.getPlaSytoreAvailability ==
            GooglePlayServicesAvailability.success &&
        CheckInternet.isConnected) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isOpened = false;
  final botToastBuilder = BotToastInit();
  // This widget is the root of your application.
  final FirebaseAnalytics? analytics =
      FirebaseInit.token != null ? FirebaseAnalytics.instance : null;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () {
        Wakelock.enable();

        return MultiBlocProvider(
          providers: [
            BlocProvider<MyProjectCubit>(
                create: (BuildContext context) => MyProjectCubit()),
            BlocProvider<MyHousesCubit>(
              create: (BuildContext context) => MyHousesCubit(),
            ),
            BlocProvider<MyFloorCubit>(
              create: (BuildContext context) => MyFloorCubit(),
            ),
            BlocProvider<MyRoomsCubit>(
              create: (BuildContext context) => MyRoomsCubit(),
            ),
            BlocProvider<MyPeopleCubit>(
              create: (BuildContext context) => MyPeopleCubit(),
            ),
            BlocProvider<MyTravelCubit>(
              create: (BuildContext context) => MyTravelCubit(),
            ),
          ],
          child: MaterialApp(
            supportedLocales: const [
              Locale("en"),
            ],
            debugShowCheckedModeBanner: false,
            title: 'Book Now Demo',
            builder: (context, child) {
              if (!isOpened) {
                log(TBIBFontStyle.h4.fontSize.toString());
                ScreenUtil.setContext(context);
                TBIBFontStyle.h1 = TBIBFontStyle.h1
                    .copyWith(fontSize: TBIBFontStyle.h1.fontSize!.sp);
                TBIBFontStyle.h2 = TBIBFontStyle.h2
                    .copyWith(fontSize: TBIBFontStyle.h2.fontSize!.sp);
                TBIBFontStyle.h3 = TBIBFontStyle.h3
                    .copyWith(fontSize: TBIBFontStyle.h3.fontSize!.sp);
                TBIBFontStyle.h4 = TBIBFontStyle.h4
                    .copyWith(fontSize: TBIBFontStyle.h4.fontSize!.sp);

                TBIBFontStyle.h5 = TBIBFontStyle.h5
                    .copyWith(fontSize: TBIBFontStyle.h5.fontSize!.sp);

                TBIBFontStyle.h6 = TBIBFontStyle.h6
                    .copyWith(fontSize: TBIBFontStyle.h6.fontSize!.sp);
                TBIBFontStyle.b1 = TBIBFontStyle.b1
                    .copyWith(fontSize: TBIBFontStyle.b1.fontSize!.sp);
                TBIBFontStyle.b2 = TBIBFontStyle.b2
                    .copyWith(fontSize: TBIBFontStyle.b2.fontSize!.sp);
                BotToastInit();
                isOpened = true;
              }

              child = child; //do something
              child = botToastBuilder(context, child);
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child);
            },
            theme: ThemeData(
              primarySwatch: Colors.brown,
              primaryColor: mainColor,
              scaffoldBackgroundColor: Colors.white,
              iconTheme: IconThemeData(color: mainColor),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  primary: buttonColor,
                ),
              ),
            ),
            home: CheckInternet.isConnected &&
                    GoogleServesesChecker.getPlaSytoreAvailability ==
                        GooglePlayServicesAvailability.success
                ? const SplashScreen()
                : CheckInternet.isConnected
                    ? GoogleServesesChecker.getPlaSytoreAvailability !=
                            GooglePlayServicesAvailability.success
                        ? Scaffold(
                            body: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Center(
                                child: Text(
                                  "Google Services issue ",
                                  style: TBIBFontStyle.h4,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        : Scaffold(
                            body: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Center(
                                child: Text(
                                  "Device Issue",
                                  style: TBIBFontStyle.h4,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                    : Scaffold(
                        body: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              "Open app with Internet please",
                              style: TBIBFontStyle.h4,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
            navigatorObservers: [
              BotToastNavigatorObserver(),
              analytics != null
                  ? FirebaseAnalyticsObserver(analytics: analytics!)
                  : NavigatorObserver(),
            ],
          ),
        );
      },
    );
  }
}
