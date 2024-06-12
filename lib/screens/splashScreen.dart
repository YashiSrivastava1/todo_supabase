import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/screens/home.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
with SingleTickerProviderStateMixin{
  @override
  void initState()
  {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds: 4), (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> Home(),));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    overlays: SystemUiOverlay.values
    );
    // TODO: implement dispose
    super.dispose();
  }
  
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
           colors: [Colors.black, Colors.white],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        SizedBox(height: 20),
        Text(
          'Welcome to TODO APP',
          style: TextStyle(fontStyle: FontStyle.normal,
          color: Colors.white,
          fontSize: 30,
          ),
        ),
         Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: 25),
        child: Lottie.asset('assets/loader.json'),
      ),
    ),
      ],),
      ),
    );
  }
}

class SystemUIMode {
}