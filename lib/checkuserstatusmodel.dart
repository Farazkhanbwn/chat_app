import 'dart:convert';

class CheckUserModel {
  String? receiverid;
  String? status;
  String? checkid;
  CheckUserModel({
    this.receiverid,
    this.status,
    this.checkid,
  });

  CheckUserModel copyWith({
    String? receiverid,
    String? status,
    String? checkid,
  }) {
    return CheckUserModel(
      receiverid: receiverid ?? this.receiverid,
      status: status ?? this.status,
      checkid: checkid ?? this.checkid,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (receiverid != null) {
      result.addAll({'receiverid': receiverid});
    }
    if (status != null) {
      result.addAll({'status': status});
    }
    if (checkid != null) {
      result.addAll({'checkid': checkid});
    }

    return result;
  }

  factory CheckUserModel.fromMap(Map<String, dynamic> map) {
    return CheckUserModel(
      receiverid: map['receiverid'],
      status: map['status'],
      checkid: map['checkid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckUserModel.fromJson(String source) =>
      CheckUserModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CheckUserModel(receiverid: $receiverid, status: $status, checkid: $checkid)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CheckUserModel &&
        other.receiverid == receiverid &&
        other.status == status &&
        other.checkid == checkid;
  }

  @override
  int get hashCode => receiverid.hashCode ^ status.hashCode ^ checkid.hashCode;
}
