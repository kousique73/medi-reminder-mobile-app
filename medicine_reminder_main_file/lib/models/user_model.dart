class UserModel {
  String name;
  String email;
  String createdAt;
  String uid;
  String password; // Add password to the model

  UserModel({
    required this.name,
    required this.email,
    required this.uid,
    required this.createdAt,
    required this.password, // Include password in constructor
  });

  // from map - getting the data from the server
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      createdAt: map['createdAt'] ?? '',
      password: map['password'] ?? '', // Map the password from Firestore
    );
  }

  // to map - sending the data to the server
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      "createdAt": createdAt,
      "password": password, // Include password when sending to Firestore
    };
  }
}
