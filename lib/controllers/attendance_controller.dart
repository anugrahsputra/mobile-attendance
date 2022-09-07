import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_attendance/database/attendance_db.dart';
import 'package:mobile_attendance/models/attendance_model.dart';

class AttendanceController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxList<AttendanceModel> listAttendance = <AttendanceModel>[].obs;

  // change master location here
  final center = const LatLng(-6.869231646115821, 107.5901644503454);

  Position? currentPosition;

  Future getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      return Future.error('Location service are disbled.');
    }
  }

  Future getListAttendances() async {
    isLoading.value = true;

    try {
      final response = await AttDatabase.instance.readAllAttendances();

      listAttendance.clear();
      listAttendance.addAll(response);

      isLoading.value = false;
    } catch (e) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future addAttendance(String name) async {
    if (currentPosition == null) {
      Fluttertoast.showToast(msg: 'Please enable your GPS');
      return;
    }

    try {
      final distance = Geolocator.distanceBetween(
        currentPosition!.latitude,
        currentPosition!.longitude,
        center.latitude,
        center.longitude,
      );
      log('distance: $distance');

      if (distance > 50) {
        Fluttertoast.showToast(
            msg: 'Attendance must be less or 50 meters from center point');
        return;
      }

      await AttDatabase.instance.create(
        AttendanceModel(
          name: name,
          latitude: currentPosition!.latitude,
          longtitude: currentPosition!.longitude,
          createdAt: DateTime.now(),
        ),
      );
      getListAttendances();

      Fluttertoast.showToast(msg: 'Attendance success');
      Get.back();
    } catch (e) {
      log('error submit: ${e.toString()}');
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
