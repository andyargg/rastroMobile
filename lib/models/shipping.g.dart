// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shipping _$ShippingFromJson(Map<String, dynamic> json) => Shipping(
  productName: json['productName'] as String,
  description: json['description'] as String?,
  status: $enumDecode(_$ShippingStatusEnumMap, json['status']),
  courier: json['courier'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ShippingToJson(Shipping instance) => <String, dynamic>{
  'productName': instance.productName,
  'status': _$ShippingStatusEnumMap[instance.status]!,
  'description': instance.description,
  'courier': instance.courier,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$ShippingStatusEnumMap = {
  ShippingStatus.delivered: 'delivered',
  ShippingStatus.inTransit: 'inTransit',
  ShippingStatus.pending: 'pending',
  ShippingStatus.error: 'error',
};
