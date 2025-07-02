class AICharacter {
  final int id;
  final String name;
  final String occupation;
  final String profileImage;
  final String status;
  final String systemPrompt;
  final String professional;
  final String? bio;

  AICharacter({
    required this.id,
    required this.name,
    required this.occupation,
    required this.profileImage,
    required this.status,
    required this.systemPrompt,
    required this.professional,
    this.bio,
  });

  factory AICharacter.fromJson(Map<String, dynamic> json) {
    return AICharacter(
      id: json['id'],
      name: json['name'],
      occupation: json['occupation'],
      profileImage: json['profile_image'],
      status: json['status'],
      systemPrompt: json['system_prompt'],
      professional: json['professional'],
      bio: json['bio'],
    );
  }
}
