import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rastro/blocs/shipment_bloc/events/shipment_event.dart';
import 'package:rastro/blocs/shipment_bloc/shipment_bloc.dart';
import 'package:rastro/helpers/courier_assets.dart';
import 'package:rastro/models/shipment.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/utils/styles/app_styles.dart';

class ShippingCard extends StatelessWidget {
  final Shipment shipment;

  const ShippingCard({
    super.key,
    required this.shipment,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ShipmentBloc>();
    return GestureDetector(
      onLongPressStart: (details) => _showContextMenu(context, details.globalPosition, bloc),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 12),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: AspectRatio(
          aspectRatio: 4 / 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 15,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                  child: Image.asset(
                    courierLogos[shipment.courier] ?? 'assets/images/default.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.local_shipping, size: 40, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 85,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              shipment.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              shipment.courier,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF666666),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Envío: ${DateFormat('dd/MM/yy').format(shipment.entryDate)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF999999),
                                  ),
                                ),
                                if (shipment.exitDate != null) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    'Llegada: ${DateFormat('dd/MM/yy').format(shipment.exitDate!)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF4CAF50),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: shipment.statusColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: shipment.statusShadowColor,
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        shipment.status,
                        style: TextStyle(
                          color: shipment.statusTextColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset position, ShipmentBloc bloc) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogCtx, _, __) {
        return GestureDetector(
          onTap: () => Navigator.pop(dialogCtx),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Stack(
                children: [
                  Positioned(
                    left: position.dx - 60,
                    top: position.dy,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _contextAction(
                              label: 'Rastrear',
                              icon: Icons.search,
                              color: Colors.blue,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                              onTap: () {
                                Navigator.pop(dialogCtx);
                                bloc.add(TrackShipment(shipment));
                              },
                            ),
                            Container(height: 0.5, color: Colors.grey.shade200),
                            _contextAction(
                              label: 'Editar',
                              icon: Icons.edit,
                              color: AppColors.primary,
                              borderRadius: BorderRadius.zero,
                              onTap: () {
                                Navigator.pop(dialogCtx);
                                _showEditSheet(context, bloc);
                              },
                            ),
                            Container(height: 0.5, color: Colors.grey.shade200),
                            _contextAction(
                              label: 'Borrar',
                              icon: Icons.delete,
                              color: Colors.red,
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                              onTap: () {
                                Navigator.pop(dialogCtx);
                                _showDeleteConfirm(context, bloc);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _contextAction({
    required String label,
    required IconData icon,
    required Color color,
    required BorderRadius borderRadius,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: 16, color: color)),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, ShipmentBloc bloc) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogCtx, _, __) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: Colors.black.withValues(alpha: 0.3),
            alignment: Alignment.center,
            child: AlertDialog(
              title: const Text('Confirmar'),
              content: const Text('¿Estás seguro de que querés borrar este envío?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    bloc.add(DeleteShipment(shipment.id));
                    Navigator.pop(dialogCtx);
                  },
                  child: const Text('Borrar', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditSheet(BuildContext context, ShipmentBloc bloc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _EditShipmentForm(shipment: shipment, bloc: bloc),
      ),
    );
  }
}

class _EditShipmentForm extends StatefulWidget {
  final Shipment shipment;
  final ShipmentBloc bloc;

  const _EditShipmentForm({required this.shipment, required this.bloc});

  @override
  State<_EditShipmentForm> createState() => _EditShipmentFormState();
}

class _EditShipmentFormState extends State<_EditShipmentForm> {
  late final TextEditingController _nameCtrl;
  late String _courier;
  late String _status;

  static const _statuses = ['Pendiente', 'En tránsito', 'Entregado'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.shipment.name);
    _courier = widget.shipment.courier;
    _status = widget.shipment.status;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) return;
    final updated = widget.shipment.copyWith(
      name: _nameCtrl.text.trim(),
      courier: _courier,
      status: _status,
    );
    widget.bloc.add(EditShipment(updated));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: SingleChildScrollView(
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
            Center(child: Text('Editar envío', style: AppTextStyles.title)),
            const SizedBox(height: 24),

            Text('Producto', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text('Empresa', style: AppTextStyles.label),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: courierLogos.keys.map((c) {
                final selected = _courier == c;
                return GestureDetector(
                  onTap: () => setState(() => _courier = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.inputFill,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.divider,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      c,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selected ? AppColors.textDark : AppColors.tertiary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            Text('Estado', style: AppTextStyles.label),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _statuses.map((s) {
                final selected = _status == s;
                return GestureDetector(
                  onTap: () => setState(() => _status = s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.inputFill,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.divider,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selected ? AppColors.textDark : AppColors.tertiary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: AppButtonStyles.primary,
                child: const Text('GUARDAR', style: AppTextStyles.button),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
