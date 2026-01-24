import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rastro/blocs/shipping_bloc/events/shipping_event.dart';
import 'package:rastro/blocs/shipping_bloc/shipping_bloc.dart';
import 'package:rastro/helpers/courier_assets.dart';
import 'package:rastro/models/shipping.dart';
import 'package:rastro/utils/enums/statuses.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/utils/styles/app_styles.dart';

class ShippingCard extends StatelessWidget {
  final Shipping shipping;

  const ShippingCard({
    super.key,
    required this.shipping,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ShippingBloc>();
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
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                  child: Image.asset(
                    courierLogos[shipping.courier]!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.local_shipping, size: 40, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 85,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            shipping.productName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF000000),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            shipping.courier,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(shipping.createdAt),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: shipping.status.getColor(),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: shipping.status.getShadowColor(),
                            offset: Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        shipping.status.getLabel(),
                        style: TextStyle(
                          color: shipping.status.getTextColor(),
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

  void _showContextMenu(BuildContext context, Offset position, ShippingBloc bloc) {
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
                              label: 'Editar',
                              icon: Icons.edit,
                              color: AppColors.primary,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
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

  void _showDeleteConfirm(BuildContext context, ShippingBloc bloc) {
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
                    bloc.add(DeleteShipping(shipping));
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

  void _showEditSheet(BuildContext context, ShippingBloc bloc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _EditShippingForm(shipping: shipping, bloc: bloc),
      ),
    );
  }
}

class _EditShippingForm extends StatefulWidget {
  final Shipping shipping;
  final ShippingBloc bloc;

  const _EditShippingForm({required this.shipping, required this.bloc});

  @override
  State<_EditShippingForm> createState() => _EditShippingFormState();
}

class _EditShippingFormState extends State<_EditShippingForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late String _courier;
  late ShippingStatus _status;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.shipping.productName);
    _descCtrl = TextEditingController(text: widget.shipping.description ?? '');
    _courier = widget.shipping.courier;
    _status = widget.shipping.status;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) return;
    final updated = widget.shipping.copyWith(
      productName: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      courier: _courier,
      status: _status,
    );
    widget.bloc.add(EditShipping(original: widget.shipping, updated: updated));
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

            Text('Descripción', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextField(
              controller: _descCtrl,
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
              children: ShippingStatus.values.map((s) {
                final selected = _status == s;
                return GestureDetector(
                  onTap: () => setState(() => _status = s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? s.getColor() : AppColors.inputFill,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? s.getTextColor() : AppColors.divider,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      s.getLabel(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selected ? s.getTextColor() : AppColors.tertiary,
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
