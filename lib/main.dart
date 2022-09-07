import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_attendance/routes/route_names.dart';

import 'routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Attendance',
      getPages: AppPages.appPages,
      initialRoute: RouteNames.home,
    );
  }
}
