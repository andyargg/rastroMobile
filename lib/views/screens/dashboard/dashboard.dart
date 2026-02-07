import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rastro/blocs/shipping_bloc/events/shipping_event.dart';
import 'package:rastro/blocs/shipping_bloc/shipping_bloc.dart';
import 'package:rastro/blocs/shipping_bloc/states/shipping_state.dart';
import 'package:rastro/utils/enums/statuses.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/views/screens/dashboard/widgets/courier_breakdown.dart';
import 'package:rastro/views/screens/dashboard/widgets/recent_shippings_panel.dart';
import 'package:rastro/views/screens/dashboard/widgets/status_summary_row.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShippingBloc()..add(LoadShippingEvent()),
      child: const _DashboardView(),
    );
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
      body: BlocBuilder<ShippingBloc, ShippingState>(
        builder: (context, state) {
          if (state is ShippingLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ShippingErrorState) {
            return Center(child: Text(state.message));
          }
          if (state is ShippingLoadedState) {
            final shippings = state.shippings;
            final total = shippings.length;
            final delivered = shippings
                .where((s) => s.status == ShippingStatus.delivered)
                .length;
            final inTransit = shippings
                .where((s) => s.status == ShippingStatus.inTransit)
                .length;
            final pending = shippings
                .where((s) => s.status == ShippingStatus.pending)
                .length;

            final recent = List.of(shippings)
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
                              child: CourierBreakdown(shippings: shippings),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: RecentShippingsPanel(
                                recentShippings: recentThree,
                              ),
                            ),
                          ],
                        )
                      else ...[
                        CourierBreakdown(shippings: shippings),
                        const SizedBox(height: 16),
                        RecentShippingsPanel(recentShippings: recentThree),
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
