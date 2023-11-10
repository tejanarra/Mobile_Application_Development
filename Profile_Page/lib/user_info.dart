class UserInfo {
  final String name;
  final String picPath;
  final String area;
  final int age;
  final double height;
  final String nationality;
  final List<Interests> interests;
  final List<DisInterests> disinterests;
  final List<ContactDetails> contact;

  UserInfo(
      {required this.name,
      required this.picPath,
      required this.area,
      required this.age,
      required this.height,
      required this.nationality,
      required this.interests,
      required this.disinterests,
      required this.contact});
}

class Interests {
  final String name;
  final String logo;

  Interests({
    required this.name,
    required this.logo,
  });
}

class DisInterests {
  final String name;
  final String logo;

  DisInterests({
    required this.name,
    required this.logo,
  });
}

class ContactDetails {
  final String phone;
  final String email;
  final String mailing;

  ContactDetails({
    required this.phone,
    required this.email,
    required this.mailing,
  });
}
