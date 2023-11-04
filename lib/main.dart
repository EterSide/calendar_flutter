import 'package:alarm/alarm.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fast_app_base/common/notification.dart';
import 'package:fast_app_base/viewmodel/calendar_viewmodel.dart';
import 'package:fast_app_base/viewmodel/category_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'common/data/preference/app_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  FlutterLocalNotification.init();
  Future.delayed(const Duration(seconds: 3),FlutterLocalNotification.requestPermissions());
  await CalendarViewModel.initializeHive();
  await CategoryViewModel.initializeHive();
  await EasyLocalization.ensureInitialized();
  await AppPreferences.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Alarm.init(showDebugLogs: true);
  await initializeDateFormatting();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ko')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      useOnlyLangCode: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => CalendarViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => CategoryViewModel(),
          )
        ],
        child: const App(),
      ),
    ),
  );
}
