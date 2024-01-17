import 'package:delivery_app/auth/blocs/auth_bloc.dart';
import 'package:delivery_app/auth/models/user_model.dart';
import 'package:delivery_app/food/views/list_food_page.dart';
import 'package:delivery_app/orders/create_order_page/views/create_order_page.dart';
import 'package:delivery_app/orders/views/order_details_page.dart';
import 'package:delivery_app/orders/views/orders_page.dart';
import 'package:delivery_app/orders/views/search_orders_page.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:delivery_app/settings/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Page<dynamic> page() => const MaterialPage<void>(child: HomePage());

  static String routeName = 'home';
  static GoRoute route = GoRoute(
    name: routeName,
    path: '/',
    builder: (context, state) {
      return const HomePage();
    },
    routes: [
      SearchOrdersPage.route,
      CreateOrderPage.route,
      OrderDetailsPage.route,
    ],
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: const HomePage(),
        transitionDuration: const Duration(milliseconds: 1500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      );
    },
  );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    final pages = _pages(user);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.home)),
      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _bottomNavigationBar(l10n),
    );
  }

  List<Widget> _pages(User user) {
    return <Widget>[
      const OrdersPage(),
      const ListFoodPage(),
      SettingsPage(user: user),
    ];
  }

  BottomNavigationBar _bottomNavigationBar(AppLocalizations l10n) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.deepPurple,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_cart),
          label: l10n.orders,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.food_bank),
          label: l10n.food,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: l10n.settings,
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
