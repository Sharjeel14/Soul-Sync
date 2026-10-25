class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String profileImageUrl;
  final String bio;
  final String dob;
  final DateTime? createdAt;
  final bool isEmailVerified;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.profileImageUrl,
    this.bio = '',
    this.dob = '',
    this.createdAt,
    this.isEmailVerified = false,
  });

  // Backward compatibility getters for existing widgets
  String get fullName => name;
  String get mobile => phone;
  String get profileImage => profileImageUrl;
  String get imageUrl => profileImageUrl;
  String get genderId => gender;
  String get customerId => uid;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: (json['uid'] ?? json['CustomerID'] ?? '').toString(),
      name: (json['name'] ?? json['FullName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? json['Mobile'] ?? '').toString(),
      gender: (json['gender'] ?? json['GenderID'] ?? '').toString(),
      profileImageUrl: (json['profileImageUrl'] ?? json['FileImage'] ?? '').toString(),
      bio: (json['bio'] ?? '').toString(),
      dob: (json['dob'] ?? json['DOB'] ?? '').toString(),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is DateTime
              ? json['createdAt'] as DateTime
              : DateTime.tryParse(json['createdAt'].toString()))
          : null,
      isEmailVerified: json['isEmailVerified'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'dob': dob,
      'createdAt': createdAt?.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      // Compatibility keys
      'FullName': name,
      'Mobile': phone,
      'FileImage': profileImageUrl,
      'CustomerID': uid,
      'GenderID': gender,
      'DOB': dob,
    };
  }

  factory UserModel.fromSupabase(Map<String, dynamic> map, [String? docId]) {
    return UserModel(
      uid: (map['uid'] ?? map['id'] ?? docId ?? '').toString(),
      name: (map['name'] ?? map['FullName'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      phone: (map['phone'] ?? map['Mobile'] ?? '').toString(),
      gender: (map['gender'] ?? map['GenderID'] ?? '').toString(),
      profileImageUrl: (map['profile_image_url'] ??
              map['profileImageUrl'] ??
              map['FileImage'] ??
              '')
          .toString(),
      bio: (map['bio'] ?? '').toString(),
      dob: (map['dob'] ?? map['DOB'] ?? '').toString(),
      createdAt: (map['created_at'] != null || map['createdAt'] != null)
          ? ((map['created_at'] ?? map['createdAt']) is DateTime
              ? (map['created_at'] ?? map['createdAt']) as DateTime
              : DateTime.tryParse(
                  (map['created_at'] ?? map['createdAt']).toString()))
          : null,
      isEmailVerified:
          map['is_email_verified'] == true || map['isEmailVerified'] == true,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'profile_image_url': profileImageUrl,
      'bio': bio,
      'dob': dob,
      'created_at':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'is_email_verified': isEmailVerified,
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> map, [String? docId]) =>
      UserModel.fromSupabase(map, docId);

  Map<String, dynamic> toFirestore() => toSupabase();

  factory UserModel.empty() => const UserModel(
        uid: '',
        name: '',
        email: '',
        phone: '',
        gender: 'male',
        profileImageUrl: '',
        bio: '',
        dob: '',
        isEmailVerified: false,
      );

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? profileImageUrl,
    String? bio,
    String? dob,
    DateTime? createdAt,
    bool? isEmailVerified,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      dob: dob ?? this.dob,
      createdAt: createdAt ?? this.createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
