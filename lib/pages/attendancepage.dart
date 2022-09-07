import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/attendance_controller.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _controller = Get.put(AttendanceController());

  final _formKey = GlobalKey<FormState>();
  late GoogleMapController mapController;
  StreamSubscription<Position>? positionStream;
  TextEditingController inputName = TextEditingController();
  // change master center point lat and long here
  final LatLng _center = const LatLng(-6.869231646115821, 107.5901644503454);

  final Set<Circle> _circles = {
    Circle(
      circleId: const CircleId('circle'),
      center: const LatLng(-6.869231646115821, 107.5901644503454),
      radius: 50,
      fillColor: Colors.blue.withOpacity(0.2),
      strokeWidth: 0,
    )
  };

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('marker'),
      position: LatLng(-6.869231646115821, 107.5901644503454),
      infoWindow: InfoWindow(title: 'Attendance Point'),
    )
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  listenLocationChange() async {
    try {
      await _controller.getCurrentLocation();

      positionStream = Geolocator.getPositionStream().listen(
        (Position position) {
          _controller.currentPosition = position;
        },
        cancelOnError: true,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Please enable your gps first');
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    listenLocationChange();
  }

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GoogleMap(
              myLocationEnabled: true,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 17.0,
              ),
              circles: _circles,
              markers: _markers,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: inputName,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: 'Your Name',
                      labelText: 'Your Name',
                      border: OutlineInputBorder(),
                      focusColor: Colors.blue,
                    ),
                    validator: (String? value) {
                      if (value == null) {
                        return 'Please input your name';
                      }

                      if (value.isEmpty) {
                        return 'Please input your name';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _controller.addAttendance(inputName.text.trim());
                      }
                    },
                    child: const Text('Attend'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
