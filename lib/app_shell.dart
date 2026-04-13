import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/budget_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/add_transaction_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    CategoriesScreen(),
    BudgetScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTransactionScreen())),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(icon: Icon(Icons.dashboard, color: _selectedIndex == 0 ? Theme.of(context).colorScheme.primary : Colors.grey), onPressed: () => _onItemTapped(0)),
            IconButton(icon: Icon(Icons.category, color: _selectedIndex == 1 ? Theme.of(context).colorScheme.primary : Colors.grey), onPressed: () => _onItemTapped(1)),
            const SizedBox(width: 40), // The space for the FAB
            IconButton(icon: Icon(Icons.account_balance_wallet, color: _selectedIndex == 2 ? Theme.of(context).colorScheme.primary : Colors.grey), onPressed: () => _onItemTapped(2)),
            // Add a placeholder for a potential 4th item if needed or adjust spacing
            const SizedBox(width: 1), 
          ],
        ),
      ),
    );
  }
}