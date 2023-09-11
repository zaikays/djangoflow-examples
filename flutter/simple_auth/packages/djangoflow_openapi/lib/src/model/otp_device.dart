//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:djangoflow_openapi/src/model/type_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'otp_device.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OTPDevice {
  /// Returns a new [OTPDevice] instance.
  OTPDevice({

     this.id,

     this.name,

    required  this.type,

     this.confirmed,

     this.key,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false
  )


  final int? id;



  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false
  )


  final String? name;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false
  )


  final TypeEnum type;



  @JsonKey(
    
    name: r'confirmed',
    required: false,
    includeIfNull: false
  )


  final bool? confirmed;



  @JsonKey(
    
    name: r'key',
    required: false,
    includeIfNull: false
  )


  final String? key;



  @override
  bool operator ==(Object other) => identical(this, other) || other is OTPDevice &&
     other.id == id &&
     other.name == name &&
     other.type == type &&
     other.confirmed == confirmed &&
     other.key == key;

  @override
  int get hashCode =>
    id.hashCode +
    name.hashCode +
    type.hashCode +
    confirmed.hashCode +
    (key == null ? 0 : key.hashCode);

  factory OTPDevice.fromJson(Map<String, dynamic> json) => _$OTPDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$OTPDeviceToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}
