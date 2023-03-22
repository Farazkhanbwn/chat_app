import 'dart:convert';

class FriendModel {
  String? friendName;
  String? friendId;
  FriendModel({
    this.friendName,
    this.friendId,
  });

  FriendModel copyWith({
    String? friendName,
    String? friendId,
  }) {
    return FriendModel(
      friendName: friendName ?? this.friendName,
      friendId: friendId ?? this.friendId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (friendName != null) {
      result.addAll({'friendName': friendName});
    }
    if (friendId != null) {
      result.addAll({'friendId': friendId});
    }

    return result;
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      friendName: map['friendName'],
      friendId: map['friendId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendModel.fromJson(String source) =>
      FriendModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'FriendModel(friendName: $friendName, friendId: $friendId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FriendModel &&
        other.friendName == friendName &&
        other.friendId == friendId;
  }

  @override
  int get hashCode => friendName.hashCode ^ friendId.hashCode;
}
