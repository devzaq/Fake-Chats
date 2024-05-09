class ChatUser {
  ChatUser({
    required this.image,
    required this.name,
    required this.about,
    required this.createdAt,
    required this.lastActive,
    required this.id,
    required this.isOnline,
    required this.email,
    required this.pushToken,
  });
   String? image;
   String? name;
   String? about;
   String? createdAt;
   String? lastActive;
   String? id;
   bool? isOnline;
   String? email;
   String? pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image ??= json['image'];
    name ??= json['name'];
    about ??= json['about'];
    createdAt ??= json['created_at'];
    lastActive ??= json['last_active'];
    id ??= json['id'];
    isOnline ??= json['is_online'];
    email ??= json['email'];
    pushToken ??= json['push_token'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['about'] = about; 
    data['created_at'] = createdAt;
    data['last_active'] = lastActive;
    data['id'] = id;
    data['is_online'] = isOnline;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}