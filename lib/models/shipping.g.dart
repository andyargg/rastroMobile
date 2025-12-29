// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shipping _$ShippingFromJson(Map<String, dynamic> json) => Shipping(
  productName: json['productName'] as String,
  description: json['description'] as String?,
  status: json['status'] as String,
  courier: json['courier'] as String,
);

Map<String, dynamic> _$ShippingToJson(Shipping instance) => <String, dynamic>{
  'productName': instance.productName,
  'status': instance.status,
  'description': instance.description,
  'courier': instance.courier,
};
