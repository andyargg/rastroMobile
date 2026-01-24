import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rastro/blocs/shipping_bloc/events/shipping_event.dart';
import 'package:rastro/blocs/shipping_bloc/shipping_bloc.dart';
import 'package:rastro/blocs/shipping_bloc/states/shipping_state.dart';
import 'package:rastro/routes/app_router.dart';
import 'package:rastro/utils/styles/app_colors.dart';
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
        child: Stack(
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
        ),
      ),
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
