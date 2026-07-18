import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class MainNavigationPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationPage({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(index),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryGreen.withOpacity(0.1),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 11),
        ),
        
        destinations: const [

          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.primaryGreen),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.eco_outlined),
            selectedIcon: Icon(Icons.eco, color: AppColors.primaryGreen),
            label: 'Crops',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map, color: AppColors.primaryGreen),
            label: 'Mapping',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble, color: AppColors.primaryGreen),
            label: 'AI Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups, color: AppColors.primaryGreen),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primaryGreen),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../core/theme/app_colors.dart';

// class MainNavigationPage extends StatelessWidget {
//   final StatefulNavigationShell navigationShell;

//   const MainNavigationPage({
//     super.key,
//     required this.navigationShell,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: navigationShell,
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 16,
//               offset: const Offset(0, -4),
//             ),
//           ],
//         ),
//         child: NavigationBar(
//           selectedIndex: navigationShell.currentIndex,
//           onDestinationSelected: (index) => navigationShell.goBranch(index),
//           backgroundColor: Colors.transparent,
//           indicatorColor: AppColors.primaryGreen.withOpacity(0.12),
//           labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//           height: 80,
//           destinations: [
//             _buildNavigationDestination(
//               icon: Icons.dashboard_outlined,
//               selectedIcon: Icons.dashboard,
//               label: 'Home',
//             ),
//             _buildNavigationDestination(
//               icon: Icons.eco_outlined,
//               selectedIcon: Icons.eco,
//               label: 'Crops',
//             ),
//             _buildNavigationDestination(
//               icon: Icons.map_outlined,
//               selectedIcon: Icons.map,
//               label: 'Mapping',
//             ),
//             _buildNavigationDestination(
//               icon: Icons.chat_bubble_outline,
//               selectedIcon: Icons.chat_bubble,
//               label: 'Chat',
//             ),
//             _buildNavigationDestination(
//               icon: Icons.groups_outlined,
//               selectedIcon: Icons.groups,
//               label: 'Community',
//             ),
//             _buildNavigationDestination(
//               icon: Icons.person_outline,
//               selectedIcon: Icons.person,
//               label: 'Profile',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   NavigationDestination _buildNavigationDestination({
//     required IconData icon,
//     required IconData selectedIcon,
//     required String label,
//   }) {
//     return NavigationDestination(
//       icon: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4),
//         child: Icon(icon, size: 24),
//       ),
//       selectedIcon: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4),
//         child: Icon(selectedIcon, color: AppColors.primaryGreen, size: 24),
//       ),
//       label: label,
//     );
//   }
// }
