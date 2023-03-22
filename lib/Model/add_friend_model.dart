// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddFriendModel {
  String? receiverId;
  String? receiverName;
  String? senderid;
  String? sendername;
  String? requestId;
  String? status;
  String? time;
  AddFriendModel({
    this.receiverId,
    this.receiverName,
    this.senderid,
    this.sendername,
    this.requestId,
    this.status,
    this.time,
  });

  AddFriendModel copyWith({
    String? receiverId,
    String? receiverName,
    String? senderid,
    String? sendername,
    String? requestId,
    String? status,
    String? time,
  }) {
    return AddFriendModel(
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      senderid: senderid ?? this.senderid,
      sendername: sendername ?? this.sendername,
      requestId: requestId ?? this.requestId,
      status: status ?? this.status,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'receiverId': receiverId,
      'receiverName': receiverName,
      'senderid': senderid,
      'sendername': sendername,
      'requestId': requestId,
      'status': status,
      'time': time,
    };
  }

  factory AddFriendModel.fromMap(Map<String, dynamic> map) {
    return AddFriendModel(
      receiverId: map['receiverId'] != null ? map['receiverId'] as String : null,
      receiverName: map['receiverName'] != null ? map['receiverName'] as String : null,
      senderid: map['senderid'] != null ? map['senderid'] as String : null,
      sendername: map['sendername'] != null ? map['sendername'] as String : null,
      requestId: map['requestId'] != null ? map['requestId'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      time: map['time'] != null ? map['time'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddFriendModel.fromJson(String source) => AddFriendModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddFriendModel(receiverId: $receiverId, receiverName: $receiverName, senderid: $senderid, sendername: $sendername, requestId: $requestId, status: $status, time: $time)';
  }

  @override
  bool operator ==(covariant AddFriendModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.receiverId == receiverId &&
      other.receiverName == receiverName &&
      other.senderid == senderid &&
      other.sendername == sendername &&
      other.requestId == requestId &&
      other.status == status &&
      other.time == time;
  }

  @override
  int get hashCode {
    return receiverId.hashCode ^
      receiverName.hashCode ^
      senderid.hashCode ^
      sendername.hashCode ^
      requestId.hashCode ^
      status.hashCode ^
      time.hashCode;
  }
}
