import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic App Icon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const DynamicIconPage(),
    );
  }
}

class DynamicIconPage extends StatefulWidget {
  const DynamicIconPage({super.key});

  @override
  State<DynamicIconPage> createState() => _DynamicIconPageState();
}

class _DynamicIconPageState extends State<DynamicIconPage> {
  String _currentIcon = 'Day';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentIcon();
  }

  Future<void> _loadCurrentIcon() async {
    if (mounted) {
      setState(() {
        _currentIcon ='Day';
      });
    }
  }

  Future<void> _changeIcon({required bool isNight}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (isNight) {
        _currentIcon = 'Night';
      } else {
        _currentIcon = 'Day';
      }
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change icon: ${e.message}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic App Icon'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Change Your App Icon',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select an icon below to update the app launcher icon.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            _IconOptionCard(
              title: 'Day Icon',
              subtitle: 'Bright icon for daytime',
              assetPath: 'assets/icons/day_icon.png',
              isSelected: _currentIcon == 'Day',
              accentColor: Colors.amber,
              onTap: () => _changeIcon(isNight: false),
            ),
            const SizedBox(height: 16),
            _IconOptionCard(
              title: 'Night Icon',
              subtitle: 'Dark icon for night mode',
              assetPath: 'assets/icons/night_icon.png',
              isSelected: _currentIcon == 'Night',
              accentColor: Colors.indigo,
              onTap: () => _changeIcon(isNight: true),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'On Android, the icon changes on the home screen immediately. '
                      'On iOS, a system confirmation will appear.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconOptionCard extends StatelessWidget {
  const _IconOptionCard({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String assetPath;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.08)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? accentColor : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                assetPath,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: accentColor, size: 28),
          ],
        ),
      ),
    );
  }
}
