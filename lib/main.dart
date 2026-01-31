import 'dart:html' as html;
import 'dart:ui_web' as ui_web;


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

void main() {
  usePathUrlStrategy(); // removes #/ from URLs on Flutter web
  runApp(const FitQuestLanding());
}

class FitQuestLanding extends StatelessWidget {
  const FitQuestLanding({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomePage()),
        GoRoute(path: '/privacy', builder: (_, __) => const PrivacyPage()),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF111827),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          // Wider so the videos can be BIG
          constraints: const BoxConstraints(maxWidth: 1200),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            children: [
              const SizedBox(height: 8),
              const Text(
                'Fit Quest',
                style: TextStyle(fontSize: 46, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              const Text(
                'A social, gamified fitness tracker. Log workouts, share progress, and level up.',
                style: TextStyle(
                  fontSize: 18,
                  height: 1.4,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 22),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Replace with your Play Store listing once you have it.
                      // Example: https://play.google.com/store/apps/details?id=YOUR.PACKAGE
                    },
                    child: const Text('Download on Google Play'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.go('/privacy'),
                    child: const Text('Privacy Policy'),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              const Text(
                'Support: support@fitquest.space',
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 38),
              const _SectionHeader(
                title: 'See Fit Quest in action',
                subtitle: 'Two quick clips that show the vibe and the core flows.',
              ),
              const SizedBox(height: 16),

              // BIG by default: stacked full-width cards
              const PromoVideoCard(
                title: 'Promo video #1',
                description: '54-second overview: account setup, friends, sharing, importing.',
                assetPath: 'assets/videos/promo1.mp4',
              ),
              const SizedBox(height: 20),
              const PromoVideoCard(
                title: 'Promo video #2',
                description: '1:20 deep dive: exercise history, suggested sets, form video + import.',
                assetPath: 'assets/videos/promo2.mp4',
              ),

              const SizedBox(height: 34),
              const Divider(height: 1),
              const SizedBox(height: 14),

              Row(
                children: [
                  TextButton(
                    onPressed: () => context.go('/privacy'),
                    child: const Text('Privacy Policy'),
                  ),
                  const SizedBox(width: 8),
                  const Text('•', style: TextStyle(color: Colors.black38)),
                  const SizedBox(width: 8),
                  Text(
                    '© ${DateTime.now().year} Fit Quest',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PromoVideoCard extends StatelessWidget {
  final String title;
  final String description;
  final String assetPath;

  const PromoVideoCard({
    super.key,
    required this.title,
    required this.description,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF4B5563),
              height: 1.35,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 14),

          // BIG 16:9 frame, native browser controls => fullscreen button works
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: const Color(0xFF0B1220),
                child: kIsWeb
                    ? _NativeHtmlVideo(assetPath: assetPath)
                    : const Center(
                        child: Text(
                          'Video preview is available on web.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          const Text(
            'Tip: Use the fullscreen icon in the video controls.',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _NativeHtmlVideo extends StatefulWidget {
  final String assetPath;
  const _NativeHtmlVideo({required this.assetPath});

  @override
  State<_NativeHtmlVideo> createState() => _NativeHtmlVideoState();
}

class _NativeHtmlVideoState extends State<_NativeHtmlVideo> {
  late final String _viewType;
  html.VideoElement? _video;

  @override
  void initState() {
    super.initState();

    // Unique view type per widget instance
    _viewType = 'fq-video-${widget.assetPath}-${DateTime.now().microsecondsSinceEpoch}';

    // Use native HTML5 <video> for reliable fullscreen + controls on web
    final v = html.VideoElement()
      ..src = widget.assetPath
      ..controls = true
      ..autoplay = false
      ..loop = false
      ..preload = 'metadata'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = '0'
      ..style.margin = '0'
      ..style.padding = '0'
      ..style.objectFit = 'cover'
      ..setAttribute('playsinline', 'true');

    _video = v;

    // Register with Flutter web
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) => v);

  }

  @override
  void dispose() {
    _video?.pause();
    _video = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF4B5563), height: 1.35),
        ),
      ],
    );
  }
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: const Text(
            '''
Privacy Policy – Fit Quest

Last updated: 2026-01-30

Fit Quest provides fitness tracking and social features.

Data we collect:
- Email and username (account creation)
- Workout data (exercises, sets, reps, weights)
- Content you upload (such as form videos)
- Basic diagnostics for reliability and support

How we use data:
- To provide core app functionality
- To enable social features you choose to use
- To improve performance and reliability

Data sharing:
- Data is stored and processed using third-party services such as Supabase.
- We do not sell personal data.

Data retention:
- Data is retained while your account is active.
- You may request deletion by contacting support@fitquest.space.

Contact:
support@fitquest.space
''',
            style: TextStyle(height: 1.5),
          ),
        ),
      ),
    );
  }
}
