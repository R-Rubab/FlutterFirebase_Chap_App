class ChatUser {
  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.online,
    required this.id,
    required this.lastActive,
    required this.createAt,
    required this.email,
    required this.pushToken,
  });
  late String image;
  late String about;
  late String name;
  late bool online;
  late String id;
  late String lastActive;
  late String createAt;
  late String email;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    online = json['online'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    createAt = json['create_at'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['online'] = online;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['create_at'] = createAt;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
