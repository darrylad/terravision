import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terravision/main.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(27, 0, 36, 1),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 70,
                ),
                welcomeText(),
                const SizedBox(
                  height: 300,
                ),
                const Text(
                    'Nostrud excepteur nisi reprehenderit esse amet. Ea dolor labore consectetur commodo non deset. \n \nVoluptate sint eiusmod ex dolore aliquip adipisicing nostrud ea sit. Consectetur dolore dolor id ad aliqua do non dolore aliqua. Anim quis pariatur ut aute pariatur consequat laborum ea mollit cillum.',
                    style: TextStyle(
                      color: Color.fromRGBO(222, 239, 255, 0.6),
                    )),
                const SizedBox(
                  height: 50,
                ),
                continueButton(context),
              ],
            ),
          ),
        ));
  }

  ElevatedButton continueButton(context) {
    return ElevatedButton(
        style: ButtonStyle(
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
          foregroundColor: MaterialStateProperty.all<Color>(
              const Color.fromRGBO(20, 0, 33, 1)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          )),
          shadowColor: MaterialStateProperty.all<Color>(
            const Color.fromRGBO(255, 254, 208, 1),
          ),
          elevation: MaterialStateProperty.all<double>(0),
          splashFactory: InkSparkle.splashFactory,
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          // Navigator.pop(context);
        },
        child: const Text('Continue'));
  }

  ShaderMask welcomeText() {
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
        'Welcome',
        style: GoogleFonts.inter(
          fontSize: 45,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
