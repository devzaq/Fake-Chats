class Message {
  Message({
    required this.toId,
    required this.msg,
    required this.read,
    required this.sent,
    required this.type,
    required this.fromId,
  });
  late String toId;
  late String msg;
  late String read;
  late String sent;
  late Type type;
  late String fromId;

  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    sent = json['sent '].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    fromId = json['fromId'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['msg'] = msg;
    data['read'] = read;
    data['sent '] = sent;
    data['type'] = type.name;
    data['fromId'] = fromId;
    return data;
  }
}

enum Type{text,image}