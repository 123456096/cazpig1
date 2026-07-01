class UserModel {
  final String email;
  final String age;
  final int xp;
  final int level;
  final int currentLevelReached;
  final int lives;
  final int streak;
  final int pigments;
  final bool isOffline;
  final String title;
  final List<String> badges;

  UserModel({
    required this.email,
    required this.age,
    required this.xp,
    required this.level,
    required this.currentLevelReached,
    required this.lives,
    required this.streak,
    required this.pigments,
    required this.isOffline,
    required this.title,
    required this.badges,
  });

  factory UserModel.initial({
    required String email,
    required String age,
    bool isOffline = false,
  }) {
    return UserModel(
      email: email,
      age: age,
      xp: 1250,
      level: 5,
      currentLevelReached: 1,
      lives: 5,
      streak: 5, // Reflejado en las capturas
      pigments: 591, // Reflejado en las capturas
      isOffline: isOffline,
      title: "Cazador Experto",
      badges: ["Primer Trazo", "Racha Color", "Ojo Mágico"],
    );
  }

  UserModel copyWith({
    String? email,
    String? age,
    int? xp,
    int? level,
    int? currentLevelReached,
    int? lives,
    int? streak,
    int? pigments,
    bool? isOffline,
    String? title,
    List<String>? badges,
  }) {
    return UserModel(
      email: email ?? this.email,
      age: age ?? this.age,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      currentLevelReached: currentLevelReached ?? this.currentLevelReached,
      lives: lives ?? this.lives,
      streak: streak ?? this.streak,
      pigments: pigments ?? this.pigments,
      isOffline: isOffline ?? this.isOffline,
      title: title ?? this.title,
      badges: badges ?? this.badges,
    );
  }
}
