import 'package:rastro/models/shipment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShipmentService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String? get _userId => _supabase.auth.currentUser?.id;

  Future<List<Shipment>> getAll() async {
    final response = await _supabase
        .from('shipments')
        .select()
        .order('entry_date', ascending: false);

    return (response as List)
        .map((json) => Shipment.fromJson(json))
        .toList();
  }

  Future<Shipment> create({
    required String name,
    required String trackingNumber,
    String? description,
    required String status,
    required String courier,
  }) async {
    final shipment = Shipment(
      id: '',
      name: name,
      trackingNumber: trackingNumber,
      description: description,
      status: status,
      courier: courier,
      entryDate: DateTime.now(),
    );

    final response = await _supabase
        .from('shipments')
        .insert({
          ...shipment.toInsertJson(),
          'user_id': _userId,
        })
        .select()
        .single();

    return Shipment.fromJson(response);
  }

  Future<Shipment> update(Shipment shipment) async {
    final response = await _supabase
        .from('shipments')
        .update(shipment.toUpdateJson())
        .eq('id', shipment.id)
        .select()
        .single();

    return Shipment.fromJson(response);
  }

  Future<void> delete(String id) async {
    await _supabase.from('shipments').delete().eq('id', id);
  }
}
