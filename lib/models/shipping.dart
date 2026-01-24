import 'package:json_annotation/json_annotation.dart';
import 'package:rastro/utils/enums/statuses.dart';

part 'shipping.g.dart';

@JsonSerializable()
class Shipping {
  final String productName;
  final ShippingStatus status;
  final String? description;
  final String courier;
  final DateTime createdAt;



  Shipping({
    required this.productName,
    this.description,
    required this.status,
    required this.courier,
    required this.createdAt,
  });

  factory Shipping.fromJson(Map<String, dynamic> json) =>
    _$ShippingFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingToJson(this);

  Shipping copyWith({
    String? productName,
    String? description,
    ShippingStatus? status,
    String? courier,
  }) {
    return Shipping(
      productName: productName ?? this.productName,
      description: description ?? this.description,
      status: status ?? this.status,
      courier: courier ?? this.courier,
      createdAt: createdAt,
    );
  }

  factory Shipping.getBaseShipping(Shipping shipping, ShippingStatus newstatus) {
    return Shipping(
      productName: shipping.productName,
      description: shipping.description,
      status: newstatus,
      courier: shipping.courier,
      createdAt: shipping.createdAt,
    );
  }
} 