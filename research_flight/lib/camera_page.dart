import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'bottom_bar.dart';
import 'flight_info.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  FlightInfo flightInfo = FlightInfo(
    isDeparture: false, // 出発か到着かを示す
    flightNumber: 'NH 22', // フライト番号
    airplaneCode: 'B777-200ER', // 機体コード
    airline: 'All Nippon Airways', // 航空会社名
    departureCity: '東京', // 出発都市
    arrivalCity: '大阪', // 到着都市
    scheduledTime: DateTime(2023, 12, 1, 17, 30), // 予定出発時間
    actualDepartureTime: DateTime(2023, 12, 1, 17, 35), // 実際の出発時間
    actualArrivalTime: DateTime(2023, 12, 1, 15, 00), // 実際の到着時間
    actualPushbackTime: DateTime(2023, 12, 1, 17, 20), // プッシュバック時間
    lateMinutes: 5, // 遅延時間（分）
  );
  double _currentZoomLevel = 1.0;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![0]);
  }

  Future<void> takePictureAndUpload() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      final XFile picture = await _cameraController.takePicture();
      uploadImage(picture.path);
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadImage(String imagePath) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('https://8f5c-192-218-175-131.ngrok-free.app'));
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        final responseStream = await response.stream.bytesToString();
        final responseData = json.decode(responseStream);
        // JSONデータからFlightInfoを作成
        final _lightInfo = FlightInfo.fromJson(responseData);
        setState(() {
          flightInfo = _lightInfo;
        });
      } else {
        print('Failed to upload image');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        body: SlidingUpPanel(
           maxHeight: 350,
            minHeight: 130,
            backdropEnabled: true,
            backdropTapClosesPanel: true,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            color: const Color(0xFFEBEBEB).withOpacity(0.95),
        panel: BottomBar(flightInfo: flightInfo),
    body: SafeArea(
      child: Stack(children: [
        _cameraController.value.isInitialized
            ? GestureDetector(
                onScaleUpdate: (details) {
                  // Adjust the zoom level on pinch
                  _currentZoomLevel =
                      (_currentZoomLevel * details.scale).clamp(1.0, 5.0);
                  _cameraController.setZoomLevel(_currentZoomLevel);
                },
                child: CameraPreview(_cameraController),
              )
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 130.0), // 下部の余白
            child: InkWell(
              onTap: takePictureAndUpload,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent, // 透明な背景
                  shape: BoxShape.circle, // 円形
                  border: Border.all(
                    color: Colors.white, // 白色の枠線
                    width: 3.0, // 枠線の太さ
                  ),
                ),
                padding: const EdgeInsets.all(2.0),
                child: const Icon(
                  Icons.circle,
                  color: Colors.white,
                  size: 50, // アイコンのサイズ
                ), // アイコンの内側の余白
              ),
            ),
          ),
        ),
      ]),
    )));
  }
}
