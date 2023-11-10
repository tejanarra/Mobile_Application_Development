import 'package:cs442_mp1/profile_page.dart';
import 'package:flutter/material.dart';
import 'user_info.dart';

void main() {
  UserInfo user = UserInfo(
      name: "Popeye the Sailor",
      picPath: "assets/images/popeye.png",
      area: "Florida",
      age: 35,
      height: 5.9, // in feet
      nationality: "American",
      interests: [
        Interests(
          name: "Music",
          logo: "assets/images/music.jpeg",
        ),
        Interests(
          name: "Cycling",
          logo: "assets/images/cycling.png",
        ),
        Interests(
          name: "Photography",
          logo: "assets/images/photo.png",
        ),
        Interests(
          name: "Travelling",
          logo: "assets/images/globe.png",
        ),
        Interests(
          name: "Meditation",
          logo: "assets/images/meditate.png",
        ),
      ],
      disinterests: [
        DisInterests(
          name: "Parties",
          logo: "assets/images/nightlife.png",
        ),
        DisInterests(
          name: "High Altitude's",
          logo: "assets/images/mountain.png",
        ),
        DisInterests(
          name: "Cooking Shows",
          logo: "assets/images/cook.png",
        ),
      ],
      contact: [
        ContactDetails(
            phone: '999-888-2233',
            email: 'popeyelikestoeat@spinach.com',
            mailing: 'Stay Strong Eat Healthy Street, FL')
      ]);

  runApp(MyApp(
    user: user,
  ));
}

class MyApp extends StatelessWidget {
  final UserInfo user;
  const MyApp({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: const Text(
            'Tinder Profile',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          centerTitle: true,
          elevation: 10.0,
        ),
        body: ProfilePage(
          user: user,
        ),
      ),
    );
  }
}
