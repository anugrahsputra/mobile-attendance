import 'package:get/get.dart';
import 'package:mobile_attendance/pages/attendancepage.dart';

import '../pages/homepage.dart';
import 'route_names.dart';

class AppPages {
  static final appPages = [
    GetPage(
      name: RouteNames.home,
      page: () => const Homepage(),
    ),
    GetPage(
      name: RouteNames.attendancePage,
      page: () => const AttendancePage(),
    ),
  ];
}
