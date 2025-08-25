import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sampleintegratenfcekyc/ekyc_nfc_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/config/.env');
  runApp(const EkycNfcApp());
}

class EkycNfcApp extends StatelessWidget {
  const EkycNfcApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final lightScheme = ShadColorScheme.fromName('green');
    final darkScheme =
        ShadColorScheme.fromName('green', brightness: Brightness.dark);

    return ShadApp(
      title: 'Ekyc NFC',
      debugShowCheckedModeBanner: false,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: lightScheme,
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: darkScheme,
      ),
      home: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: const ScaffoldMessenger(
          child: EkycNfcScreen(),
        ),
      ),
    );
  }
}
