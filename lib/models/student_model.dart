class StudentModel {
  final String idNumber;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String yearLevel;
  final String category;
  final String address;
  final String phoneNumber;
  final DateTime birthDate;
  final String? emailAddress;

  StudentModel({
    required this.idNumber,
    required this.yearLevel,
    required this.category,
    required this.address,
    required this.phoneNumber,
    required this.birthDate,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.emailAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_number': idNumber,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'year_level': yearLevel,
      'category': category,
      'address': address,
      'phone_number': phoneNumber,
      'birth_date': birthDate,
      'email_address': emailAddress,
    };
  }
}
