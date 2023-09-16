import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:terravision/camera_page.dart';
import 'package:terravision/history_page.dart';
import 'package:terravision/more_page.dart';
import 'package:terravision/upload_page.dart';

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Error in fetching the cameras: $e');
  }
  runApp(const MyApp());
}

List<CameraDescription> cameras = [];

Future<void> mainCam() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Error in fetching the cameras: $e');
  }
  // runApp(MyApp());
  // const CameraPage();
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //       // builder: (context) => CameraPage(camera: firstCamera)),
  //       builder: (context) => const CameraPage()),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    mainCam();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TerraVision',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var selectedIndex = 0;

  void changePage(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

// final GoRouter routes = GoRouter(routes: <RouteBase>[
//   GoRoute(
//       path: 'lib/welcome_page.dart',
//       builder: (BuildContext context, GoRouterState state) {
//         return const WelcomePage();
//       }),
//   GoRoute(
//       path: 'lib/main.dart',
//       builder: (BuildContext context, GoRouterState state) {
//         return const HomePage(showWelcomePage: true);
//       }),
// ]);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 1;

  // get showWelcomePage => widget.showWelcomePage;
  // bool showWelcomePage = true;

  // @override
  // void initState() {
  //   bool showWelcomePage = widget.showWelcomePage;
  //   super.initState();
  //   // loadWelcomePageState();
  // }

  // Future<void> loadWelcomePageState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     showWelcomePage = prefs.getBool('showWelcomePage') ?? true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    mainCam();
    // var colorScheme = Theme.of(context).colorScheme;

    // Widget page = const WelcomePage(
    //     // onIndexChanged: changeSelectedIndex,
    //     ); // a varaible to store the active page displayed
    Widget page = const CameraPage();
    switch (selectedIndex) {
      case 0:
        // page = WelcomePage(
        //   onIndexChanged: changeSelectedIndex,
        // );
        page = const HistoryPage();
        break;
      case 1:
        page = const CameraPage();
        break;
      case 2:
        page = const UploadPage();
        break;
      case 3:
        page = const MorePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: Colors.black,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return navigationBar(mainArea);
  }

  Scaffold navigationBar(ColoredBox mainArea) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  // bottom: false,
                  top:
                      false, // this was done to remove extra white space appearing on top of the bottom navigation bar on android
                  child: BottomNavigationBar(
                    showUnselectedLabels: true,
                    backgroundColor: Colors.black,
                    selectedItemColor: const Color.fromARGB(255, 255, 166, 166),
                    unselectedItemColor: colorScheme.onPrimary,
                    items: const [
                      BottomNavigationBarItem(
                        backgroundColor: Colors.black,
                        icon: Icon(Icons.history),
                        label: 'History',
                      ),
                      BottomNavigationBarItem(
                        backgroundColor: Colors.black,
                        icon: Icon(Icons.camera_alt_outlined),
                        label: 'Camera',
                      ),
                      BottomNavigationBarItem(
                          backgroundColor: Colors.black,
                          icon: Icon(Icons.upload_file),
                          label: 'Upload'),
                      BottomNavigationBarItem(
                        backgroundColor: Colors.black,
                        icon: Icon(Icons.more_horiz),
                        label: 'More',
                      )
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    unselectedLabelTextStyle: TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w500),
                    selectedLabelTextStyle: TextStyle(
                        color: colorScheme.brightness == Brightness.light
                            ? colorScheme.primary
                            : colorScheme.primary,
                        fontWeight: FontWeight.w500),
                    backgroundColor: Colors.black87,
                    unselectedIconTheme:
                        IconThemeData(color: colorScheme.onPrimary),
                    extended: constraints.maxWidth >= 600,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.history),
                        label: Text('History'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.camera_alt),
                        label: Text('Camera'),
                      ),
                      NavigationRailDestination(
                          icon: Icon(Icons.upload_file), label: Text('Upload')),
                      NavigationRailDestination(
                        icon: Icon(Icons.more_horiz),
                        label: Text('More'),
                      )
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}
