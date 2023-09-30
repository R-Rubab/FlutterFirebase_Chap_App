class Message {
  Message({
    required this.formId,
    required this.msg,
    required this.read,
    required this.told,
    required this.type,
    required this.send,
  });
  late final String formId;
  late final String msg;
  late final String read;
  late final String told;
  late final String send;
  late final Type type;

  Message.fromJson(Map<String, dynamic> json) {
    formId = json['formId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    send = json['send'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['formId'] = formId;
    data['msg'] = msg;
    data['read'] = read;
    data['told'] = told;
    data['type'] = type.name;
    data['send'] = send;
    return data;
  }
}

enum Type { text, image }
