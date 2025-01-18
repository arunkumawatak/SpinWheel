class UserModel {
  String? uid;
  String? email;
  int coins;
  int freeSpins;
  String? lastSpinTime;
  int spinsCompleted; // New field to track the number of spins

  UserModel({
    this.uid,
    this.email,
    this.coins = 0,
    this.freeSpins = 5,
    this.lastSpinTime,
    this.spinsCompleted = 0, // Initialize with 0 spins
  });

  // Convert UserModel to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'coins': coins,
      'freeSpins': freeSpins,
      'lastSpinTime': lastSpinTime,
      'spinsCompleted': spinsCompleted, // Add spinsCompleted here
    };
  }

  // Convert Firebase map to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      coins: map['coins'],
      freeSpins: map['freeSpins'],
      lastSpinTime: map['lastSpinTime'],
      spinsCompleted: map['spinsCompleted'] ?? 0,
    );
  }
}
