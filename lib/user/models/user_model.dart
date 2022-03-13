class UserModel {
  String userId;
  String mobileNumber;
  String firstName;
  String lastName;
  var preparingFor;
  String city;
  String email;
  String password;
  int dob;
  int subUpTo;
  bool isActiveUser;
  String fcmDeviceKey;
  String displayPicture;
  String role;
  String deviceId;

  UserModel(
      {this.userId = '',
      this.mobileNumber = '',
      this.firstName = '',
      this.lastName = '',
      this.preparingFor = const [''],
      this.city = '',
      this.email = '',
      this.password = '',
      this.dob = 0,
      this.subUpTo = 0,
      this.isActiveUser = false,
      this.fcmDeviceKey = '',
      this.displayPicture = '',
      this.role = 'user',
      this.deviceId = ''});

  UserModel.fromMap(Map map)
      : this(
          userId: map['userId'],
          mobileNumber: map['mobileNumber'],
          firstName: map['firstName'],
          lastName: map['lastName'],
          preparingFor: map['preparingFor'],
          city: map['city'],
          email: map['email'],
          password: map['password'],
          dob: map['dob'],
          subUpTo: map['subUpTo'],
          isActiveUser: map['isActiveUser'],
          fcmDeviceKey: map['fcmDeviceKey'],
          displayPicture: map['displayPicture'],
          role: map['role'],
          deviceId: map['deviceId'],
        );

  Map<String, dynamic> asMap() => {
        'userId': userId,
        'mobileNumber': mobileNumber,
        'firstName': firstName,
        'lastName': lastName,
        'preparingFor': preparingFor,
        'city': city,
        'email': email,
        'password': password,
        'dob': dob,
        'subUpTo': subUpTo,
        'isActiveUser': isActiveUser,
        'fcmDeviceKey': fcmDeviceKey,
        'displayPicture': displayPicture,
        'role': role,
        'deviceId': deviceId
      };
}

/// Devaraj Biradar  - 8123555224
/// DEV224
///

///Mobile Number
///OTP
///Email - Password
///FirstName And LastName
///
/// Preparing For
/// CITY
/// DOB
///
