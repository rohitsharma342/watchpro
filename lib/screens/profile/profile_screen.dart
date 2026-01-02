import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/watch_provider.dart';
import '../../widgets/custom_button.dart';
import '../../app/routes.dart';
import 'widgets/user_info_section.dart';
import 'widgets/listing_item.dart';
import 'widgets/order_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<UserProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.splash,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, WatchProvider>(
      builder: (context, userProvider, watchProvider, child) {
        if (userProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        final user = userProvider.currentUser;
        if (user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 80,
                  color: AppTheme.textLight,
                ),
                const SizedBox(height: 16),
                Text(
                  'Not logged in',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Login',
                  onPressed: () {
                    userProvider.login();
                  },
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Profile',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            IconButton(
                              onPressed: _handleLogout,
                              icon: const Icon(
                                Icons.logout,
                                color: AppTheme.errorColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        UserInfoSection(user: user),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Listings',
                                watchProvider.userListings.length.toString(),
                                Icons.watch,
                                AppTheme.pastelGreen,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Saved',
                                watchProvider.savedWatches.length.toString(),
                                Icons.favorite,
                                AppTheme.pastelPink,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Orders',
                                userProvider.orders.length.toString(),
                                Icons.shopping_bag,
                                AppTheme.pastelBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: AppTheme.primaryColor,
                      unselectedLabelColor: AppTheme.textSecondary,
                      indicatorColor: AppTheme.primaryColor,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: 'My Listings'),
                        Tab(text: 'Saved'),
                        Tab(text: 'Orders'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildListingsTab(watchProvider),
                _buildSavedTab(watchProvider),
                _buildOrdersTab(userProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryDark, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListingsTab(WatchProvider watchProvider) {
    if (watchProvider.userListings.isEmpty) {
      return _buildEmptyState(
        Icons.watch_outlined,
        'No listings yet',
        'Start selling your luxury watches',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: watchProvider.userListings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final watch = watchProvider.userListings[index];
        return ListingItem(
          watch: watch,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.watchDetails,
              arguments: watch,
            );
          },
        );
      },
    );
  }

  Widget _buildSavedTab(WatchProvider watchProvider) {
    if (watchProvider.savedWatches.isEmpty) {
      return _buildEmptyState(
        Icons.favorite_outline,
        'No saved watches',
        'Save watches you love for later',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: watchProvider.savedWatches.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final watch = watchProvider.savedWatches[index];
        return ListingItem(
          watch: watch,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.watchDetails,
              arguments: watch,
            );
          },
          showRemoveButton: true,
          onRemove: () => watchProvider.toggleSaved(watch.id),
        );
      },
    );
  }

  Widget _buildOrdersTab(UserProvider userProvider) {
    if (userProvider.orders.isEmpty) {
      return _buildEmptyState(
        Icons.shopping_bag_outlined,
        'No orders yet',
        'Your purchase history will appear here',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: userProvider.orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = userProvider.orders[index];
        return OrderItem(order: order);
      },
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.pastelGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.backgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
