import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rastro/blocs/shipment_bloc/events/shipment_event.dart';
import 'package:rastro/blocs/shipment_bloc/shipment_bloc.dart';
import 'package:rastro/helpers/courier_assets.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/utils/styles/app_styles.dart';

class ModalShipping extends StatefulWidget {
  const ModalShipping({super.key});

  @override
  State<ModalShipping> createState() => _ModalShippingState();
}

class _ModalShippingState extends State<ModalShipping> {
  late TextEditingController _controllerName;
  late TextEditingController _controllerShipCode;
  String? _selectedCourier;

  @override
  void initState() {
    super.initState();
    _controllerName = TextEditingController();
    _controllerShipCode = TextEditingController();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerShipCode.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controllerName.text.trim();
    final trackingNumber = _controllerShipCode.text.trim();
    final courier = _selectedCourier;

    if (name.isEmpty || trackingNumber.isEmpty || courier == null) {
      return;
    }

    context.read<ShipmentBloc>().add(AddShipment(
      name: name,
      trackingNumber: trackingNumber,
      courier: courier,
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.tertiary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Center(
            child: Text('Agregar envío', style: AppTextStyles.title),
          ),
          const SizedBox(height: 24),

          Text('Nombre del producto', style: AppTextStyles.label),
          const SizedBox(height: 8),
          TextField(
            controller: _controllerName,
            style: AppTextStyles.textField,
            decoration: AppInputStyles.base(hintText: 'ej: Zapatillas Nike'),
          ),
          const SizedBox(height: 16),

          Text('Código de seguimiento', style: AppTextStyles.label),
          const SizedBox(height: 8),
          TextField(
            controller: _controllerShipCode,
            style: AppTextStyles.textField,
            decoration: AppInputStyles.base(hintText: 'ej: OC123456789AR'),
          ),
          const SizedBox(height: 16),

          Text('Courier', style: AppTextStyles.label),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCourier,
            hint: Text('Selecciona courier', style: AppTextStyles.hint),
            style: AppTextStyles.textField,
            icon: const Icon(LucideIcons.chevronDown, color: AppColors.tertiary),
            dropdownColor: AppColors.white,
            decoration: AppInputStyles.base(),
            items: courierLogos.keys.map((courier) => DropdownMenuItem(
              value: courier,
              child: Text(courier),
            )).toList(),
            onChanged: (value) => setState(() => _selectedCourier = value),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _submit,
              style: AppButtonStyles.primary,
              child: const Text('AGREGAR ENVÍO', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }
}
