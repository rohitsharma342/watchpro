import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../data/models/watch_model.dart';
import '../../providers/watch_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/message_provider.dart';
import '../../widgets/custom_button.dart';
import '../messaging/messaging_screen.dart';
import 'widgets/image_gallery.dart';
import 'widgets/specifications_list.dart';
import 'widgets/seller_card.dart';

class WatchDetailsScreen extends StatefulWidget {
  final WatchModel watch;

  const WatchDetailsScreen({super.key, required this.watch});

  @override
  State<WatchDetailsScreen> createState() => _WatchDetailsScreenState();
}

class _WatchDetailsScreenState extends State<WatchDetailsScreen> {
  final _currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
  bool _isPurchasing = false;

  void _showLoginPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Login Required'),
        content: const Text('Please log in to continue with this action.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _handlePurchase() async {
    final userProvider = context.read<UserProvider>();

    if (!userProvider.isLoggedIn) {
      _showLoginPrompt();
      return;
    }

    setState(() => _isPurchasing = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isPurchasing = false);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.pastelGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Order Placed!'),
            ],
          ),
          content: Text(
            'Your order for ${widget.watch.title} has been placed successfully. You will receive a confirmation email shortly.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      );
    }
  }

  void _handleMessageSeller() {
    final userProvider = context.read<UserProvider>();
    final messageProvider = context.read<MessageProvider>();

    if (!userProvider.isLoggedIn) {
      _showLoginPrompt();
      return;
    }

    messageProvider.startNewConversation(
      sellerId: widget.watch.sellerId,
      sellerName: widget.watch.sellerName,
      sellerImage: widget.watch.sellerImage,
      watchId: widget.watch.id,
      watchTitle: widget.watch.title,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagingScreen(
          sellerId: widget.watch.sellerId,
          sellerName: widget.watch.sellerName,
          watchTitle: widget.watch.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            actions: [
              Consumer<WatchProvider>(
                builder: (context, watchProvider, child) {
                  final isSaved = watchProvider.isSaved(widget.watch.id);
                  return GestureDetector(
                    onTap: () => watchProvider.toggleSaved(widget.watch.id),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isSaved ? Icons.favorite : Icons.favorite_border,
                        color:
                            isSaved ? AppTheme.errorColor : AppTheme.textPrimary,
                      ),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ImageGallery(images: widget.watch.images),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.pastelGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.watch.brand,
                                  style: const TextStyle(
                                    color: AppTheme.primaryDark,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.watch.title,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ],
                          ),
                        ),
                        if (widget.watch.isVerified)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.pastelGreen,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.verified,
                                  color: AppTheme.primaryColor,
                                  size: 28,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: AppTheme.primaryDark,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          _currencyFormat.format(widget.watch.price),
                          style:
                              Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: AppTheme.primaryColor,
                                  ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.pastelBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.watch.condition,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.watch.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                            height: 1.6,
                          ),
                    ),
                    const SizedBox(height: 24),
                    SpecificationsList(
                      specifications: widget.watch.specifications,
                    ),
                    const SizedBox(height: 24),
                    SellerCard(
                      sellerName: widget.watch.sellerName,
                      sellerImage: widget.watch.sellerImage,
                      sellerRating: widget.watch.sellerRating,
                      isVerified: widget.watch.isVerified,
                      listedDate: widget.watch.listedDate,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Message Seller',
                  onPressed: _handleMessageSeller,
                  isOutlined: true,
                  icon: Icons.chat_bubble_outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Buy Now',
                  onPressed: _handlePurchase,
                  isLoading: _isPurchasing,
                  icon: Icons.shopping_bag_outlined,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
