import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:terravision/main.dart';

// List<CameraDescription> cameras = [];

Future<void> mainCam() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Error in fetching the cameras: $e');
  }
}
//   // runApp(MyApp());
//   // const CameraPage();
//   // Navigator.push(
//   //   context,
//   //   MaterialPageRoute(
//   //       // builder: (context) => CameraPage(camera: firstCamera)),
//   //       builder: (context) => const CameraPage()),
//   // );
// }

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? controller;
  bool _isCameraInitialized = false;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    // if (controller == null) {
    //   mainCam();
    // }
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void initState() {
    mainCam();
    onNewCameraSelected(cameras[0]);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // onNewCameraSelected(controller!.description);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      mainCam();
      return;
    }

    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
      _isCameraInitialized = false;
    } else if (state == AppLifecycleState.resumed) {
      mainCam();
      // WidgetsFlutterBinding.ensureInitialized();
      // cameras = await availableCameras();
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    mainCam();
    var colorScheme = Theme.of(context).colorScheme;
    var mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 24, 4, 10),
        appBar: AppBar(
          title: const Text('Terravision'),
          titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 255, 117, 117),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(child: cameraView(colorScheme, width)),
              ),
              SafeArea(
                child: SizedBox(
                  height: height * 0.005,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  photoShutterButton(),
                  // videoRecordButton(),
                  // cameraFlipButton(),
                ],
              ),
              SizedBox(
                height: height * 0.005,
              )
            ]));
  }

  IconButton photoShutterButton() {
    return IconButton(
      icon: const Icon(
        Icons.camera_rounded,
        size: 75,
      ),
      color: Colors.white,
      onPressed: () async {
        try {
          await controller?.takePicture();
        } on CameraException catch (e) {
          debugPrint('Error taking picture: $e');
        }
      },
    );
  }

  IconButton cameraFlipButton() {
    return IconButton(
      icon: const Icon(Icons.flip_camera_ios),
      color: Colors.white,
      onPressed: () async {
        final CameraDescription cameraDescription = controller!.description;
        final CameraLensDirection direction = cameraDescription.lensDirection;
        CameraDescription newDescription;
        if (direction == CameraLensDirection.front) {
          newDescription = cameras.firstWhere((description) =>
              description.lensDirection == CameraLensDirection.back);
        } else {
          newDescription = cameras.firstWhere((description) =>
              description.lensDirection == CameraLensDirection.front);
        }
        onNewCameraSelected(newDescription);
      },
    );
  }

  IconButton videoRecordButton() {
    return IconButton(
      icon: const Icon(Icons.videocam),
      color: Colors.white,
      onPressed: () async {
        try {
          if (controller!.value.isRecordingVideo) {
            await controller?.stopVideoRecording();
          } else {
            await controller?.startVideoRecording();
          }
        } on CameraException catch (e) {
          debugPrint('Error taking video: $e');
        }
      },
    );
  }

  Container cameraView(ColorScheme colorScheme, double width) {
    return Container(
      clipBehavior: Clip.hardEdge,
      // color: colorScheme.surface,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      // foregroundDecoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(15),
      //   border: Border.all(
      //     color: controller != null &&
      //             controller!.value.isRecordingVideo
      //         ? Colors.redAccent
      //         : Colors.transparent,
      //     width: 5.0,
      //   ),
      // ),
      width: width * 0.98,
      // height: height * 0.78,
      child: _isCameraInitialized
          ? Center(
              // child: AspectRatio(
              //   aspectRatio: 1 / controller!.value.aspectRatio,
              //   child: controller!.buildPreview(),
              // ),
              child: controller!.buildPreview(),
            )
          : Container(
              color: const Color.fromARGB(255, 49, 11, 36),
              child: const Center(
                child: Text(
                  'Attempting to launch camera...',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 213, 213),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
    );
  }
}
