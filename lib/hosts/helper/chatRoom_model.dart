// ignore: file_names
class ChatRoomModel {
  String? chatRoomid;
  Map<String, dynamic>? participants;
  String? lastmessage;
  DateTime? createdAt;

  ChatRoomModel({
    required this.chatRoomid,
    required this.participants,
    required this.lastmessage,
    required this.createdAt,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomid = map["chatRoomid"];
    participants = map["participants"];
    lastmessage = map["lastmessage"];
    createdAt = map["createdAt"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "chatRoomid": chatRoomid,
      "participants": participants,
      "lastmessage": lastmessage,
      "createdAt": createdAt,
    };
  }
}
