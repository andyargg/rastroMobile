import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rastro/blocs/shipment_bloc/shipment_bloc.dart';
import 'package:rastro/blocs/shipment_bloc/states/shipment_state.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/views/screens/dashboard/widgets/courier_breakdown.dart';
import 'package:rastro/views/screens/dashboard/widgets/recent_shippings_panel.dart';
import 'package:rastro/views/screens/dashboard/widgets/status_summary_row.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DashboardView();
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textDark),
        title: const Text(
          'Resumen',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<ShipmentBloc, ShipmentState>(
        builder: (context, state) {
          if (state is ShipmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ShipmentError) {
            return Center(child: Text(state.message));
          }
          if (state is ShipmentLoaded) {
            final shipments = state.shipments;
            final total = shipments.length;
            final delivered = shipments
                .where((s) => s.status.toLowerCase() == 'entregado')
                .length;
            final inTransit = shipments
                .where((s) => s.status.toLowerCase() == 'en tránsito')
                .length;
            final pending = shipments
                .where((s) => s.status.toLowerCase() == 'pendiente')
                .length;

            final recent = List.of(shipments)
              ..sort((a, b) => b.entryDate.compareTo(a.entryDate));
            final recentThree = recent.take(3).toList();

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;
                final horizontalPadding = isWide ? 40.0 : 16.0;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatusSummaryRow(
                        total: total,
                        delivered: delivered,
                        inTransit: inTransit,
                        pending: pending,
                      ),
                      const SizedBox(height: 16),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CourierBreakdown(shipments: shipments),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: RecentShippingsPanel(
                                recentShipments: recentThree,
                              ),
                            ),
                          ],
                        )
                      else ...[
                        CourierBreakdown(shipments: shipments),
                        const SizedBox(height: 16),
                        RecentShippingsPanel(recentShipments: recentThree),
                      ],
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
