import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_attendance/controllers/attendance_controller.dart';
import 'package:mobile_attendance/database/attendance_db.dart';
import 'package:mobile_attendance/routes/route_names.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _controller = Get.put(AttendanceController());

  @override
  void initState() {
    super.initState();
    _controller.getCurrentLocation();
    _controller.getListAttendances();
  }

  @override
  void dispose() {
    AttDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mobile Attendance',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_controller.isError.value) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Error fetching data. Try again.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  onPressed: () {
                    _controller.getListAttendances();
                  },
                ),
              ],
            ),
          );
        }

        if (_controller.listAttendance.isEmpty) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No data.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: () {
                    _controller.getListAttendances();
                  },
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: _controller.listAttendance.length,
          itemBuilder: (context, index) {
            final attendance = _controller.listAttendance[index];

            return ListTile(
              title: Text(attendance.name),
              subtitle: Text(
                  DateFormat('dd MMM y H:mm:ss').format(attendance.createdAt)),
              trailing: const Text('Attended'),
            );
          },
        );
      }),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Get.toNamed(
              RouteNames.attendancePage,
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.all(10),
            ),
            child: const Text('New Attendance'),
          ),
        ),
      ),
    );
  }
}
