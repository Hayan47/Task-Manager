import 'package:equatable/equatable.dart';

class Address {
  final String address;
  final String city;
  final Coordinates coordinates;
  final String postalCode;
  final String state;

  Address({
    required this.address,
    required this.city,
    required this.coordinates,
    required this.postalCode,
    required this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      city: json['city'],
      coordinates: Coordinates.fromJson(json['coordinates']),
      postalCode: json['postalCode'],
      state: json['state'],
    );
  }
}

class Coordinates {
  final double lat;
  final double lng;

  Coordinates({required this.lat, required this.lng});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class Bank {
  final String cardExpire;
  final String cardNumber;
  final String cardType;
  final String currency;
  final String iban;

  Bank({
    required this.cardExpire,
    required this.cardNumber,
    required this.cardType,
    required this.currency,
    required this.iban,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      cardExpire: json['cardExpire'],
      cardNumber: json['cardNumber'],
      cardType: json['cardType'],
      currency: json['currency'],
      iban: json['iban'],
    );
  }
}

class Company {
  final Address address;
  final String department;
  final String name;
  final String title;

  Company({
    required this.address,
    required this.department,
    required this.name,
    required this.title,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      address: Address.fromJson(json['address']),
      department: json['department'],
      name: json['name'],
      title: json['title'],
    );
  }
}

class Hair {
  final String color;
  final String type;

  Hair({required this.color, required this.type});

  factory Hair.fromJson(Map<String, dynamic> json) {
    return Hair(
      color: json['color'],
      type: json['type'],
    );
  }
}

class Crypto {
  final String coin;
  final String wallet;
  final String network;

  Crypto({
    required this.coin,
    required this.wallet,
    required this.network,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      coin: json['coin'],
      wallet: json['wallet'],
      network: json['network'],
    );
  }
}

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String maidenName;
  final int age;
  final String gender;
  final String email;
  final String phone;
  final String username;
  final String password;
  final String birthDate;
  final String image;
  final String bloodGroup;
  final double height;
  final double weight;
  final String eyeColor;
  final Hair hair;
  final String ip;
  final Address address;
  final String macAddress;
  final String university;
  final Bank bank;
  final Company company;
  final String ein;
  final String ssn;
  final String userAgent;
  final Crypto crypto;
  final String role;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.maidenName,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.birthDate,
    required this.image,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hair,
    required this.ip,
    required this.address,
    required this.macAddress,
    required this.university,
    required this.bank,
    required this.company,
    required this.ein,
    required this.ssn,
    required this.userAgent,
    required this.crypto,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      maidenName: json['maidenName'],
      age: json['age'],
      gender: json['gender'],
      email: json['email'],
      phone: json['phone'],
      username: json['username'],
      password: json['password'],
      birthDate: json['birthDate'],
      image: json['image'],
      bloodGroup: json['bloodGroup'],
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
      eyeColor: json['eyeColor'],
      hair: Hair.fromJson(json['hair']),
      ip: json['ip'],
      address: Address.fromJson(json['address']),
      macAddress: json['macAddress'],
      university: json['university'],
      bank: Bank.fromJson(json['bank']),
      company: Company.fromJson(json['company']),
      ein: json['ein'],
      ssn: json['ssn'],
      userAgent: json['userAgent'],
      crypto: Crypto.fromJson(json['crypto']),
      role: json['role'],
    );
  }

  @override
  List<Object?> get props => [id];
}

// Helper method to create a sample user for testing
User createSampleUser({
  int id = 1,
}) {
  return User(
    id: 1,
    firstName: 'firstName',
    lastName: 'lastName',
    maidenName: 'maidenName',
    age: 10,
    gender: 'gender',
    email: 'email',
    phone: 'phone',
    username: 'username',
    password: 'password',
    birthDate: 'birthDate',
    image: 'image',
    bloodGroup: 'bloodGroup',
    height: 4,
    weight: 4,
    eyeColor: 'eyeColor',
    hair: Hair(color: 'color', type: 'type'),
    ip: 'ip',
    address: Address(
      address: 'address',
      city: 'city',
      coordinates: Coordinates(lat: 0, lng: 0),
      postalCode: 'postalCode',
      state: 'state',
    ),
    macAddress: 'macAddress',
    university: 'university',
    bank: Bank(
      cardExpire: 'cardExpire',
      cardNumber: 'cardNumber',
      cardType: 'cardType',
      currency: 'currency',
      iban: 'iban',
    ),
    company: Company(
      address: Address(
        address: 'address',
        city: 'city',
        coordinates: Coordinates(lat: 0, lng: 0),
        postalCode: 'postalCode',
        state: 'state',
      ),
      department: 'department',
      name: 'name',
      title: 'title',
    ),
    ein: 'ein',
    ssn: 'ssn',
    userAgent: 'userAgent',
    crypto: Crypto(
      coin: 'coin',
      wallet: 'wallet',
      network: 'network',
    ),
    role: 'role',
  );
}
