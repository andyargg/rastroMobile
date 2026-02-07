import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rastro/blocs/shipping_bloc/events/shipping_event.dart';
import 'package:rastro/blocs/shipping_bloc/shipping_bloc.dart';
import 'package:rastro/blocs/shipping_bloc/states/shipping_state.dart';
import 'package:rastro/models/shipping.dart';
import 'package:rastro/routes/app_router.dart';
import 'package:rastro/utils/enums/statuses.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/views/screens/dashboard/widgets/courier_breakdown.dart';
import 'package:rastro/views/screens/dashboard/widgets/recent_shippings_panel.dart';
import 'package:rastro/views/screens/dashboard/widgets/status_summary_row.dart';
import 'package:rastro/views/screens/home/widgets/footer_menu.dart';
import 'package:rastro/views/screens/home/widgets/modal_filter.dart';
import 'package:rastro/views/screens/home/widgets/modal_shipping.dart';
import 'package:rastro/views/screens/home/widgets/search_bar_card.dart';
import 'package:rastro/views/screens/home/widgets/shipping_card_builder.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShippingBloc()..add(LoadShippingEvent()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFE3E2E2),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;

            if (isWide) {
              return _buildWebLayout(context, router);
            }
            return _buildMobileLayout(context, router);
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, StackRouter router) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12.5, 56, 12.5, 5),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFC98643),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: SearchBarCard(
                  onSearchChanged: (query) {
                    context.read<ShippingBloc>().add(SearchShippings(query));
                  },
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  if (state is ShippingLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ShippingLoadedState) {
                    return ShippingCardBuilder(shippings: state.shippings);
                  }
                  if (state is ShippingErrorState) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        FooterMenu(
          onTapProfile: () => router.push(const ProfileRoute()),
          onTapAdd: () => _showAddShippingModal(context),
          onTapFilter: () => _showFilterModal(context),
        ),
      ],
    );
  }

  Widget _buildWebLayout(BuildContext context, StackRouter router) {
    return BlocBuilder<ShippingBloc, ShippingState>(
      builder: (context, state) {
        if (state is ShippingLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ShippingErrorState) {
          return Center(child: Text(state.message));
        }
        if (state is ShippingLoadedState) {
          final shippings = state.shippings;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Dashboard panel
              Expanded(
                flex: 4,
                child: _buildDashboardPanel(shippings),
              ),
              // Right: Shipping list
              Expanded(
                flex: 3,
                child: _buildShippingListPanel(context, shippings, router),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDashboardPanel(List<Shipping> shippings) {
    final total = shippings.length;
    final delivered =
        shippings.where((s) => s.status == ShippingStatus.delivered).length;
    final inTransit =
        shippings.where((s) => s.status == ShippingStatus.inTransit).length;
    final pending =
        shippings.where((s) => s.status == ShippingStatus.pending).length;

    final recent = List.of(shippings)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final recentThree = recent.take(3).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(40, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),
          StatusSummaryRow(
            total: total,
            delivered: delivered,
            inTransit: inTransit,
            pending: pending,
          ),
          const SizedBox(height: 16),
          CourierBreakdown(shippings: shippings),
          const SizedBox(height: 16),
          RecentShippingsPanel(recentShippings: recentThree),
        ],
      ),
    );
  }

  Widget _buildShippingListPanel(
    BuildContext context,
    List<Shipping> shippings,
    StackRouter router,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12.5, 24, 20, 5),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFC98643),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: SearchBarCard(
              onSearchChanged: (query) {
                context.read<ShippingBloc>().add(SearchShippings(query));
              },
            ),
          ),
        ),
        Expanded(
          child: ShippingCardBuilder(shippings: shippings),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                color: AppColors.primary,
                onPressed: () => _showFilterModal(context),
              ),
              const SizedBox(width: 16),
              FloatingActionButton(
                backgroundColor: AppColors.textDark,
                foregroundColor: AppColors.primary,
                onPressed: () => _showAddShippingModal(context),
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.person),
                color: AppColors.primary,
                onPressed: () => router.push(const ProfileRoute()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFilterModal(BuildContext context) {
    final bloc = context.read<ShippingBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const ModalFilter(),
      ),
    );
  }

  void _showAddShippingModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: const ModalShipping(),
      ),
    );
  }
}
