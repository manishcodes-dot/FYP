// import 'package:cw1/Pages/home.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'pages/login.dart';
// import 'pages/sign_in.dart';
// import 'pages/forget_password.dart';
// import 'package:provider/provider.dart';
// import 'features/notes/logic/notes_controller.dart';
// import 'features/notes/presentation/pages/notes_list_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,

//       initialRoute: '/',
//       routes: {
//         '/': (context) => const LoginPage(),
//         '/signup': (context) => const SignupPage(),
//         '/forgot-password': (context) => const ForgotPasswordPage(),
//         '/home': (context) => const HomePage(),
//       },
//     );
//   }
// }

// import 'package:cw1/Pages/home.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'pages/login.dart';
// import 'pages/sign_in.dart';
// import 'pages/forget_password.dart';
// import 'Pages/home.dart';
// import 'package:provider/provider.dart';
// import 'features/notes/logic/notes_controller.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();         // initialize Firebase
//   await dotenv.load(fileName: ".env");   // load .env variables
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Provide NotesController to the entire app
//     return ChangeNotifierProvider(
//       create: (_) => NotesController(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: '/',
//         routes: {
//           '/': (context) => const LoginPage(),
//           '/signup': (context) => const SignupPage(),
//           '/forgot-password': (context) => const ForgotPasswordPage(),
//           '/home': (context) => const HomePage(),
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/notes/logic/notes_controller.dart';
import 'Pages/home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) {
        final controller = NotesController();
        controller.fetchNotes(); // Load dummy notes
        return controller;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}





  