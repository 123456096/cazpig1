class UserModel {
  final String email;
  final String age;
  final String name;
  final String avatarUrl;
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
    required this.name,
    required this.avatarUrl,
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
    String? name,
    String? avatarUrl,
    bool isOffline = false,
  }) {
    return UserModel(
      email: email,
      age: age,
      name: name ?? "Elena Cruz",
      avatarUrl: avatarUrl ?? "assets/avatar/avatar1.jpeg",
      xp: 0,
      level: 1,
      currentLevelReached: 1,
      lives: 5,
      streak: 0, 
      pigments: 0, 
      isOffline: isOffline,
      title: "Cazador Novato",
      badges: const [],
    );
  }

  UserModel copyWith({
    String? email,
    String? age,
    String?name,
    String?avatarUrl,
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
      name:name ?? this.name,
      avatarUrl:avatarUrl ?? this.avatarUrl,
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
