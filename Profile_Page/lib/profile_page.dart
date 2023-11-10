import 'package:flutter/material.dart';
import 'user_info.dart';

class ProfilePage extends StatelessWidget {
  final UserInfo user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double size = height;
    if (width > height) {
      size = width / 2;
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: <Widget>[
        profileImage(size),
        SizedBox(height: size * 0.02),
        info(size),
        SizedBox(height: size * 0.03),
        contactInfo(user.contact, size),
        SizedBox(height: size * 0.04),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            interestsSection(size),
            disinterestsSection(size),
          ],
        )
      ],
    );
  }

  Widget profileImage(double size) {
    return Container(
      height: size * 0.3,
      //width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(user.picPath),
          fit: BoxFit.scaleDown,
          opacity: 0.9,
        ),
      ),
    );
  }

  Widget info(double size) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(75.0),
        color: const Color.fromARGB(255, 249, 119, 119),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            user.name,
            style: TextStyle(
              fontSize: size * 0.03,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${user.age} years old | ${user.height} ft | ${user.nationality}",
            style: TextStyle(
                fontSize: size * 0.02,
                color: const Color.fromARGB(255, 255, 255, 255)),
          ),
          const SizedBox(height: 10),
          Text(
            user.area,
            style: TextStyle(
                fontSize: size * 0.02,
                color: const Color.fromARGB(255, 255, 255, 255)),
          ),
        ],
      ),
    );
  }

  Widget contactInfo(List<ContactDetails> contactDetails, double size) {
    Map<String, IconData> details = {
      contactDetails[0].email: Icons.email_outlined,
      contactDetails[0].phone: Icons.phone,
      contactDetails[0].mailing: Icons.location_on,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text('Contact:',
              style: TextStyle(
                  fontSize: size * 0.03, fontWeight: FontWeight.w500)),
          const SizedBox(width: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: details.entries
                .map((entry) =>
                    contactDetailContainer(entry.key, entry.value, size))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget contactDetailContainer(String detail, IconData icon, double size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: const Color.fromARGB(255, 234, 220, 108),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: size * 0.03),
            const SizedBox(width: 5),
            Text(
              detail,
              style: TextStyle(fontSize: size * 0.03),
            ),
          ],
        ),
      ),
    );
  }

  Widget interestsSection(double size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: const Color.fromARGB(255, 164, 228, 184),
          ),
          child: Text(
            'Interests',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: size * 0.03,
            ),
          ),
        ),
        SizedBox(height: size * 0.01),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: user.interests
              .map((interest) => interestLogo(interest, size))
              .toList(),
        ),
        SizedBox(height: size * 0.20),
      ],
    );
  }

  Widget disinterestsSection(double size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: const Color.fromARGB(255, 115, 143, 196),
          ),
          child: Text(
            'Disinterests',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: size * 0.03,
            ),
          ),
        ),
        SizedBox(height: size * 0.01),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: user.disinterests
              .map((disinterest) => interestLogo(disinterest, size))
              .toList(),
        ),
        SizedBox(height: size * 0.20),
      ],
    );
  }

  Widget interestLogo(dynamic item, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Image.asset(
            item.logo,
            width: height * 0.1,
            height: height * 0.1,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: const Color.fromARGB(255, 238, 241, 250),
            ),
            child: Text(
              item.name,
              style: TextStyle(fontSize: height * 0.02),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
