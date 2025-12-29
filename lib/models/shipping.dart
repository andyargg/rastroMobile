import 'package:json_annotation/json_annotation.dart';

part 'shipping.g.dart';

@JsonSerializable()
class Shipping {
  final String productName;
  final String status;
  final String? description;
  final String courier;



  Shipping({
    required this.productName,
    this.description,
    required this.status,
    required this.courier,
  });

  factory Shipping.fromJson(Map<String, dynamic> json) =>
    _$ShippingFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingToJson(this);

  factory Shipping.getBaseShipping(Shipping shipping, String newstatus) {
    return Shipping(
      productName: shipping.productName,
      description: shipping.description,
      status: newstatus,
      courier: shipping.courier
    );
  }
}