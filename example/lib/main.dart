import 'package:flutter/material.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

void main() {
  runApp(const SpotlightTourExampleApp());
}

class SpotlightTourExampleApp extends StatelessWidget {
  const SpotlightTourExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotlight Tour Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();
  final GlobalKey _cartKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

  int _cartCount = 0;
  bool _searchOpened = false;
  bool _profileOpened = false;

  void _startTour() {
    SpotlightTour.start(
      context,
      theme: SpotlightTourTheme.material3(),
      showProgress: true,
      steps: [
        TourStep(
          targetKey: _searchKey,
          title: 'Search Products',
          description: 'Tap the search button to find products.',
          requiredAction: RequiredAction.tap,
          tooltipPosition: TooltipPosition.bottom,
          spotlightStyle: const SpotlightStyle(
            shape: SpotlightShape.roundedRectangle,
            pulseAnimation: true,
            showGlow: true,
            borderWidth: 3,
          ),
          onValidated: () {
            setState(() => _searchOpened = true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Search opened — step validated!'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
        TourStep(
          targetKey: _profileKey,
          title: 'Your Profile',
          description: 'Long-press the profile icon to open settings.',
          requiredAction: RequiredAction.longPress,
          tooltipPosition: TooltipPosition.auto,
          spotlightStyle: const SpotlightStyle(
            shape: SpotlightShape.circle,
            pulseAnimation: true,
          ),
          onValidated: () {
            setState(() => _profileOpened = true);
          },
        ),
        TourStep(
          targetKey: _cartKey,
          title: 'Shopping Cart',
          description: 'Add an item to your cart, then tap Next.',
          tooltipPosition: TooltipPosition.top,
          validator: () async => _cartCount > 0,
        ),
        TourStep(
          targetKey: _fabKey,
          title: 'Quick Add',
          description: 'Double-tap the + button to add items quickly.',
          requiredAction: RequiredAction.doubleTap,
          tooltipPosition: TooltipPosition.left,
          spotlightStyle: const SpotlightStyle(
            shape: SpotlightShape.circle,
            showGlow: true,
            borderWidth: 4,
          ),
          onValidated: () {
            setState(() => _cartCount += 2);
          },
        ),
      ],
      onComplete: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tour completed!')),
        );
      },
      onSkip: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tour skipped.')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotlight Tour Demo'),
        actions: [
          IconButton(
            key: _searchKey,
            icon: Badge(
              isLabelVisible: _searchOpened,
              child: const Icon(Icons.search),
            ),
            tooltip: 'Search',
            onPressed: () {
              setState(() => _searchOpened = true);
            },
          ),
          IconButton(
            key: _profileKey,
            icon: Badge(
              isLabelVisible: _profileOpened,
              child: const Icon(Icons.person_outline),
            ),
            tooltip: 'Profile',
            onPressed: () {
              setState(() => _profileOpened = true);
            },
          ),
          IconButton(
            key: _cartKey,
            icon: Badge(
              label: Text('$_cartCount'),
              isLabelVisible: _cartCount > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            tooltip: 'Cart',
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.waving_hand,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Interactive Onboarding',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Unlike traditional showcase packages, Spotlight Tour '
                'requires real user interaction before advancing.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _startTour,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Tour'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _cartCount++;
                    SpotlightTour.controller?.refreshValidation();
                  });
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add to Cart (for step 3)'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () => setState(() => _cartCount++),
        child: const Icon(Icons.add),
      ),
    );
  }
}
