import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleintegratenfcekyc/log_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EkycNfcApp());
}

class EkycNfcApp extends StatelessWidget {
  const EkycNfcApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const EkycNfcPage(),
    );
  }
}

class EkycNfcPage extends StatefulWidget {
  const EkycNfcPage({super.key});

  @override
  State<EkycNfcPage> createState() => _EkycNfcPageState();
}

class _EkycNfcPageState extends State<EkycNfcPage> {
  late MethodChannel _channel;
  late TextEditingController _textIdController;
  late TextEditingController _textDobController;
  late TextEditingController _textExpireController;

  @override
  void initState() {
    _channel = const MethodChannel('flutter.sdk.ekyc/integrate');
    _textIdController = TextEditingController();
    _textDobController = TextEditingController();
    _textExpireController = TextEditingController();
    super.initState();
  }

  _navigateToLog(Map<String, dynamic> json, {bool removeDialog = false}) {
    if (json.isNotEmpty) {
      if (removeDialog) {
        Navigator.of(context).pop();
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LogScreen(json: json),
        ),
      );
    }
  }

  Map<String, dynamic> _parseResult(final Map<String, dynamic> json) {
    return {
      "Avatar NFC": json["IMAGE_AVATAR_CARD_NFC"],
      "Client session": json["CLIENT_SESSION_RESULT"],
      "Log NFC": json["LOG_NFC"],
      "Hash avatar": json["HASH_AVATAR"],
      "Postcode original location": json["POST_CODE_ORIGINAL_LOCATION_RESULT"],
      "Postcode recent location": json["POST_CODE_RECENT_LOCATION_RESULT"],
      "Time scan NFC": json["TIME_SCAN_NFC"],
      "Check auth chip": json["CHECK_AUTH_CHIP_RESULT"],
      "Qrcode": json["QR_CODE_RESULT_NFC"],
    };
  }

  Future<Map<String, dynamic>> _navigateToScanNfc() async {
    try {
      final result = await _channel.invokeMethod("navigateToScanNfc", {
        "access_token": "<ACCESS_TOKEN> (including bearer)",
        "token_id": "<TOKEN_ID>",
        "token_key": "<TOKEN_KEY>",
        "card_id": _textIdController.text.trim(),
        "card_dob": _textDobController.text.trim(),
        "card_expire_date": _textExpireController.text.trim(),
      });

      final Map<String, dynamic> json = jsonDecode(result);

      return json.isEmpty ? {} : _parseResult(jsonDecode(result));
    } on PlatformException catch (e) {
      var snackBar = SnackBar(
        content: Text(e.message ?? ''),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return {};
    }
  }

  Future<Map<String, dynamic>> _navigateToNfcQrCode() async {
    try {
      final result = await _channel.invokeMethod('navigateToNfcQrCode', {
        "access_token": "<ACCESS_TOKEN> (including bearer)",
        "token_id": "<TOKEN_ID>",
        "token_key": "<TOKEN_KEY>",
      });

      final Map<String, dynamic> json = jsonDecode(result);

      return json.isEmpty ? {} : _parseResult(jsonDecode(result));
    } on PlatformException catch (e) {
      var snackBar = SnackBar(
        content: Text(e.message ?? ''),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tích hợp SDK VNPT eKYC NFC',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () async =>
                    _navigateToLog(await _navigateToNfcQrCode()),
                child: const Text('Thực hiện quét QR => Đọc chip NFC'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () async => _showMyDialog(),
                child: const Text('Thực hiện Đọc chip NFC'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nhập thông tin'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _textIdController,
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nhập số ID',
                    counterText: "",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _textDobController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nhập ngày sinh',
                    helperText: "* Định dạng: yyMMdd, vd: 950614",
                    counterText: "",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _textExpireController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nhập ngày hết hạn',
                    helperText: "* Định dạng: yyMMdd, vd: 950614",
                    counterText: "",
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () async {
                _navigateToLog(await _navigateToScanNfc(), removeDialog: true);
              },
            ),
          ],
        );
      },
    );
  }
}
