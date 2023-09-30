import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terravision/camera_page.dart';
import 'package:image_picker/image_picker.dart';

class CameraLauncherPage extends StatefulWidget {
  const CameraLauncherPage({super.key});

  @override
  State<CameraLauncherPage> createState() => _CameraLauncherPageState();
}

class _CameraLauncherPageState extends State<CameraLauncherPage> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      _showImageDialog();
    }
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(27, 0, 36, 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(1.0, 10, 1.0, 10),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                image: DecorationImage(
                  image: FileImage(_image!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                child: ElevatedButton(
                    style: actionButtonStyle(),
                    onPressed: () {},
                    child: const Text('Upload')),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: ElevatedButton(
                  style: actionButtonStyleSecondary(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ]),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(14, 0, 25, 1),
        appBar: AppBar(
          title: titleText(),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(14, 0, 25, 1),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              descriptionBox(
                  'This text will portray how terravision uses the camera to record the view and then processes it with an AI model to return the terrain data. \n \n This text will portray how terravision uses the camera to record the view and then processes it with an AI model to return the terrain data.'),
              const SizedBox(
                height: 30,
              ),
              descriptionBox(
                  'This text will portray how terravision uses the camera to record the view and then processes it with an AI model to return the terrain data.'),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: actionButtonStyle(),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CameraPage()),
                        );
                        // Navigator.pop(context);
                      },
                      child: const Text('Launch Camera')),
                  ElevatedButton(
                      style: actionButtonStyle(),
                      onPressed: () {
                        _pickImage();
                        // Navigator.pop(context);
                      },
                      child: const Text('Upload Image'))
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              descriptionBox(
                  'This text will portray how terravision uses the camera to record the view and then processes it with an AI model to return the terrain data.'),
            ],
          ),
        ));
  }

  Container descriptionBox(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromRGBO(159, 118, 255, 0.2),
      ),
      // height: 200,
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Text(
          text,
          style: GoogleFonts.inter(
              color: const Color.fromRGBO(159, 172, 255, 0.698),
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  ElevatedButton actionButton(BuildContext context, String text) {
    return ElevatedButton(
        style: actionButtonStyle(),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CameraPage()),
          );
          // Navigator.pop(context);
        },
        child: Text(text));
  }

  ButtonStyle actionButtonStyle() {
    return ButtonStyle(
      overlayColor: MaterialStateColor.resolveWith(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            // Color when the button is pressed
            return const Color.fromRGBO(
                222, 239, 255, 1); // Replace with your desired color
          }
          // Color when the button is not pressed
          return Colors.transparent; // Replace with your desired color
        },
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromRGBO(255, 254, 208, 1)),
      foregroundColor:
          MaterialStateProperty.all<Color>(const Color.fromRGBO(20, 0, 33, 1)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      )),
      shadowColor: MaterialStateProperty.all<Color>(
        const Color.fromRGBO(255, 254, 208, 1),
      ),
      elevation: MaterialStateProperty.all<double>(0),
      splashFactory: InkSparkle.splashFactory,
    );
  }

  ButtonStyle actionButtonStyleSecondary() {
    return ButtonStyle(
      overlayColor: MaterialStateColor.resolveWith(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            // Color when the button is pressed
            return const Color.fromRGBO(
                255, 254, 208, 1); // Replace with your desired color
          }
          // Color when the button is not pressed
          return Colors.transparent; // Replace with your desired color
        },
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromRGBO(169, 213, 255, 1)),
      foregroundColor:
          MaterialStateProperty.all<Color>(const Color.fromRGBO(20, 0, 33, 1)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      )),
      shadowColor: MaterialStateProperty.all<Color>(
        const Color.fromRGBO(255, 254, 208, 1),
      ),
      elevation: MaterialStateProperty.all<double>(0),
      splashFactory: InkSparkle.splashFactory,
    );
  }

  ShaderMask titleText() {
    return ShaderMask(
      shaderCallback: (Rect bounds) => const LinearGradient(
        begin: Alignment(0.0, -0.2),
        end: Alignment(0.0, 1.0),
        colors: [
          Color.fromRGBO(197, 227, 255, 1),
          Color.fromRGBO(255, 255, 145, 1)
        ],
      ).createShader(bounds),
      child: Text(
        'Terravision',
        style: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
