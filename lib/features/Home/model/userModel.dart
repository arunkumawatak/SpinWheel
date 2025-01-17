class UserModel {
  String? uid;
  String? email;
  int coins;
  int freeSpins;
  DateTime? lastSpinTime;

  UserModel({
    this.uid,
    this.email,
    this.coins = 100, // Default starting coins
    this.freeSpins = 5,
    this.lastSpinTime,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      coins: map['coins'] ?? 0,
      freeSpins: map['freeSpins'] ?? 5,
      lastSpinTime: map['lastSpinTime'] != null
          ? DateTime.parse(map['lastSpinTime'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'coins': coins,
      'freeSpins': freeSpins,
      'lastSpinTime': lastSpinTime?.toIso8601String(),
    };
  }
}
