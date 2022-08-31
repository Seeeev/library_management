class UserModel {
  final String uid;
  final String email;
  final bool isAdmin;
  final String? firstName;
  final String? middleName;
  final String? lastName;

  UserModel(
      {required this.uid,
      required this.email,
      required this.isAdmin,
      this.firstName,
      this.middleName,
      this.lastName});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'isAdmin': isAdmin,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName
    };
  }
}
