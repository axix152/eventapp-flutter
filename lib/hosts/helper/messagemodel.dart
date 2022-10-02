class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdAt;

  MessageModel(
      {required this.messageid,
      required this.sender,
      required this.text,
      required this.seen,
      required this.createdAt});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map['messageid'];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdAt = map["createdAt"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdAt": createdAt,
    };
  }
}
