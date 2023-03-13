class UserModel {
   String name;
   String email;
   String bio;
   String profilePic;
   String createdAt;
   String phoneNumber;
   String uid;

  UserModel(
      {required this.name,
      required this.email,
      required this.bio,
      required this.profilePic,
      required this.createdAt,
      required this.phoneNumber,
      required this.uid});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      bio: map["bio"] ?? "",
      profilePic: map["uid"] ?? "",
      createdAt: map["phoneNumber"] ?? "",
      phoneNumber: map["createdAt"] ?? "",
      uid: map["profilePic"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "bio": bio,
      "uid": uid,
      "profilePic": profilePic,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
    };
  }
}
