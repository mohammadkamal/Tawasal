import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ContactAccount {
  ContactAccount(
      {this.phoneNumberInternational, this.phoneNumberLocal, this.displayName});
  String phoneNumberInternational;
  int phoneNumberLocal;
  String displayName;

  factory ContactAccount.fromJson(Map<String, dynamic> json) =>
      _$ContactAccountFromJson(json);
  Map<String, dynamic> toJson() => _$ContactAccountToJson(this);
}

ContactAccount _$ContactAccountFromJson(Map<String, dynamic> json) {
  return ContactAccount(
      phoneNumberInternational: json['phoneNumberInternational'],
      phoneNumberLocal: json['phoneNumberLocal'],
      displayName: json['displayName']);
}

Map<String, dynamic> _$ContactAccountToJson(ContactAccount contactAccount) =>
    <String, dynamic>{
      'phoneNumber': contactAccount.phoneNumberInternational,
      'phoneNumberLocal': contactAccount.phoneNumberLocal,
      'displayName': contactAccount.displayName
    };
