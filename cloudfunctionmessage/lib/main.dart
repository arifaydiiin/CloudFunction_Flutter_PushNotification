import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Notify',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FirebaseMessaging _messaging;
  void registerNotification() async {

  
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in terminated state
  //uygulama tamamen kapanmış durumdayken bildirimi yakalar.
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
        var token =await FirebaseMessaging.instance.getToken();
    print("Tokenimiz: "+token.toString());
  }

  @override
  void initState() {
    registerNotification();
    checkForInitialMessage();
    
    // uygulama arkaplana atıldığında bildirim yakalar.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
    //uygulama açıkken bildirim atar.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Gelen önplan mesajı: "+message.notification!.title.toString());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify'),
        brightness: Brightness.dark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }
}
