import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:saanjalo/AuthBloc/authenticationbloc_bloc.dart';
import 'package:saanjalo/screens/SplashPage/SplashPage.dart';
import 'package:saanjalo/screens/homepage/homepage.dart';
import 'package:saanjalo/screens/login/login.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:saanjalo/screens/onboarding/onboarding.dart';
import 'package:saanjalo/simple_bloc_observer.dart';

import 'simple_bloc_observer.dart';

const List<Color> orangeGradients = [
  Color(0xFFFF9844),
  Color(0xFFFE8853),
  Color(0xFFFD7267),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Bloc.observer = SimpleBlocObserver();

  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();

  runApp(
    App(
      authenticationRepository: authenticationRepository,
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key, required this.authenticationRepository})
      : super(key: key);

  final AuthenticationRepository authenticationRepository;
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return RepositoryProvider.value(
      value: authenticationRepository,
      // ignore: always_specify_types
      child: BlocProvider(
        create: (BuildContext context) => AuthenticationblocBloc(
            authenticationRepository: authenticationRepository),
        child: const AppData(),
      ),
    );
  }
}

class AppData extends StatefulWidget {
  const AppData({
    Key? key,
  }) : super(key: key);

  @override
  _AppDataState createState() => _AppDataState();
}

class _AppDataState extends State<AppData> {
  // final _navigatorKey = GlobalKey<NavigatorState>();
  double screenHeight = 0.0;

  // NavigatorState? get _navigator => _navigatorKey.currentState;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorKey: _navigatorKey,
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      // home: Firstpage(),
      // builder: (context, child) {
      //   final double

      //   return BlocListener<AuthenticationblocBloc, AuthenticationblocState>(
      //     listenWhen: (previous, current) {
      //       return previous.status != current.status;
      //     },
      //     listener: (context, state) {
      //       switch (state.status) {
      //         case (AppStatus.authenticated):
      //           _navigator.pushAndRemoveUntil(
      //               HomePage.route(), ModalRoute.withName('/'));

      //           break;
      //         case (AppStatus.unauthenticated):
      //           _navigator.pushAndRemoveUntil(
      //               Login.route(screenHeight), ModalRoute.withName('/'));
      //           break;
      //       }
      //     },
      //     child: child,
      //   );
      // },
      home: FlowBuilder<AppStatus>(
          state: context
              .select((AuthenticationblocBloc bloc) => bloc.state.status),
          onGeneratePages: (AppStatus status, List<Page<dynamic>> pages) {
            switch (status) {
              case AppStatus.authenticated:
                return [MaterialPage<dynamic>(child: HomePage())];

              case AppStatus.unauthenticated:

              default:
                return [
                  // MaterialPage(child: OnBoarding()),
                  MaterialPage(child: Login())
                ];
            }
          }),
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}

// class Firstpage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: BlocListener<AuthenticationblocBloc, AuthenticationblocState>(
//       listener: (context, state) {
//         if (state is AuthenticationSuccess) {
//           return Login(
//             screenHeight: screenHeight,
//           );
//         } else if (state is AuthenticationFailure) {
//           return OnBoarding(screenHeight: screenHeight);
//         }
//       },
//     )
//         // body: Builder(builder: (context) {

//         //   return OnBoarding(screenHeight: screenHeight);
//         // }),
//         );
//   }
// }

// class TopWaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();

//     path.moveTo(0, size.height * 0.6);
//     path.lineTo(0.0, size.height - 50);
//     path.quadraticBezierTo(0, size.height, 50, size.height);
//     path.lineTo(size.width - 50, size.height);
//     path.quadraticBezierTo(
//         size.width, size.height, size.width, size.height - 50);
//     path.lineTo(size.width, 80);
//     path.quadraticBezierTo(size.width, 30, size.width - 50, 40);
//     path.lineTo(size.width * 0.3, 100);
//     path.quadraticBezierTo(0, size.height * .3, 0, size.height * .45);

//     // var firstControlPoint = Offset(size.width / 7, size.height - 30);
//     // var firstEndPoint = Offset(size.width / 6, size.height / 1.5);
//     // path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
//     //     firstEndPoint.dx, firstEndPoint.dy);
//     // path.lineTo(size.width, 0.0);
//     // path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }

// Widget alternateBody=Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           children: [
//             SafeArea(
//               child: Text(
//                 "Welcome to Sanjalo",
//                 style: TextStyle(
//                   backgroundColor: Colors.blueAccent,
//                   color: Colors.white,
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: ClipPath(
//                   clipper: TopWaveClipper(),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(context, PageRouteBuilder(
//                         pageBuilder: (context, animation, secondaryAnimation) {
//                           return OnBoarding();
//                         },
//                       ));
//                     },
//                     child: Hero(
//                       tag: "backGround",
//                       child: Container(
//                         width: MediaQuery.of(context).size.width * 0.8,
//                         height: MediaQuery.of(context).size.height * 0.6,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: orangeGradients,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       )
