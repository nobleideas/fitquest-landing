import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

void main() {
  usePathUrlStrategy();
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
              const PromoVideoCard(
                title: 'Promo video #1',
                description: '54-second overview of the Fit Quest experience.',
                assetPath: 'assets/videos/fq-promo1.mp4',
              ),
              const SizedBox(height: 20),
              const PromoVideoCard(
                title: 'Promo video #2',
                description: '1:20 deep dive into exercise history and form videos.',
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
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: kIsWeb
                    ? _NativeHtmlVideoWithFullscreen(assetPath: assetPath)
                    : const Center(
                        child: Text('Video is available on web.', style: TextStyle(color: Colors.white70)),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Use the ↗ button for fullscreen (more reliable than the native fullscreen control).',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _NativeHtmlVideoWithFullscreen extends StatefulWidget {
  final String assetPath;
  const _NativeHtmlVideoWithFullscreen({required this.assetPath});

  @override
  State<_NativeHtmlVideoWithFullscreen> createState() => _NativeHtmlVideoWithFullscreenState();
}

class _NativeHtmlVideoWithFullscreenState extends State<_NativeHtmlVideoWithFullscreen> {
  late final String _viewType;
  html.VideoElement? _video;
  StreamSubscription<html.Event>? _fsSub;

  @override
  void initState() {
    super.initState();

    _viewType = 'fq-video-${widget.assetPath}-${DateTime.now().microsecondsSinceEpoch}';

    // Flutter web assets are served under /assets/...
    // If widget.assetPath is "assets/videos/promo1.mp4", actual served URL becomes:
    // /assets/assets/videos/promo1.mp4
    final src = 'assets/${widget.assetPath}';

    final v = html.VideoElement()
      ..src = src
      ..controls = true
      ..preload = 'metadata'
      ..autoplay = false
      ..loop = false
      ..muted = false
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.maxWidth = '100%'
      ..style.maxHeight = '100%'
      ..style.objectFit = 'contain'
      ..style.backgroundColor = 'black'
      ..style.transform = 'none'
      ..style.setProperty('-webkit-transform', 'none')
      ..setAttribute('playsinline', 'true')
      ..setAttribute('webkit-playsinline', 'true')
      // Disable native fullscreen button where supported, because that's what's causing rotation weirdness.
      ..setAttribute('controlsList', 'nofullscreen nodownload noplaybackrate')
      ..setAttribute('disablePictureInPicture', 'true');

    _video = v;

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) => v);

    // Listen for fullscreen exit to unlock orientation (best-effort).
    _fsSub = html.document.onFullscreenChange.listen((_) async {
      final isFs = html.document.fullscreenElement != null;
      if (!isFs) {
        await _unlockOrientationBestEffort();
      }
    });
  }

  @override
  void dispose() {
    _fsSub?.cancel();
    _video?.pause();
    _video = null;
    super.dispose();
  }

  Future<void> _enterFullscreen() async {
    final v = _video;
    if (v == null) return;

    try {
      // Request fullscreen on the video element itself.
      await v.requestFullscreen();
    } catch (_) {
      // Fallback: request fullscreen on the document element.
      try {
        await html.document.documentElement?.requestFullscreen();
      } catch (_) {}
    }

    // Best-effort orientation lock: many browsers allow this ONLY in fullscreen + user gesture.
    // We lock to landscape because promo videos look best and avoids weird rotations.
    await _lockOrientationBestEffort();
  }

  Future<void> _lockOrientationBestEffort() async {
    try {
      final orientation = html.window.screen?.orientation;
      if (orientation != null) {
        // Some browsers support 'landscape' / 'portrait' or 'landscape-primary'
        await orientation.lock('landscape');
      }
    } catch (_) {
      // Ignore: not supported in this browser or blocked by permissions.
    }
  }

  Future<void> _unlockOrientationBestEffort() async {
    try {
      final orientation = html.window.screen?.orientation;
      if (orientation != null) {
        orientation.unlock();
      }
    } catch (_) {
      // Ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: Colors.black)),
        Positioned.fill(child: HtmlElementView(viewType: _viewType)),

        // Our fullscreen button (reliable). Native fullscreen disabled above.
        Positioned(
          right: 10,
          bottom: 10,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _enterFullscreen,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0x99000000),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0x33FFFFFF)),
                ),
                child: const Icon(Icons.open_in_full, color: Colors.white, size: 18),
              ),
            ),
          ),
        ),
      ],
    );
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
- Email and username
- Workout data
- Uploaded content (form videos)

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
