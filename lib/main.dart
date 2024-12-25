import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat_flutte/screens/chat_screen.dart';
import 'package:flash_chat_flutte/screens/login_screen.dart';
import 'package:flash_chat_flutte/screens/registration_screen.dart';
import 'package:flash_chat_flutte/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // qrCode.make();

  FirebaseApp app = await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (_) => WelcomeScreen(),
        LoginScreen.id: (_) => LoginScreen(),
        ChatScreen.id: (_) => ChatScreen(),
        RegistrationScreen.id: (_) => RegistrationScreen(),
      },
    );
  }
}
