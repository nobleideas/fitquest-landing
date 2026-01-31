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
                assetPath: 'assets/videos/promo1.mp4',
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

          // The video frame (no overlay controls — avoids tap conflicts)
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: kIsWeb
                    ? _NativeHtmlVideoHost(assetPath: assetPath)
                    : const Center(
                        child: Text(
                          'Video is available on web.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Fullscreen button OUTSIDE the video element (so it always registers taps)
          Align(
            alignment: Alignment.centerRight,
            child: kIsWeb
                ? _FullscreenButton(assetPath: assetPath)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// Hosts the HTML <video> element. Kept separate so the fullscreen button can be
/// outside the video and not fight with native controls.
class _NativeHtmlVideoHost extends StatefulWidget {
  final String assetPath;
  const _NativeHtmlVideoHost({required this.assetPath});

  @override
  State<_NativeHtmlVideoHost> createState() => _NativeHtmlVideoHostState();
}

class _NativeHtmlVideoHostState extends State<_NativeHtmlVideoHost> {
  late final String _viewType;
  html.VideoElement? _video;

  @override
  void initState() {
    super.initState();

    _viewType = 'fq-video-${widget.assetPath}-${DateTime.now().microsecondsSinceEpoch}';

    // Flutter web serves assets under /assets/...
    // If assetPath is "assets/videos/promo1.mp4", served URL is:
    //   /assets/assets/videos/promo1.mp4
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
      // Reduce “cast / remote playback” prompts where supported:
      ..setAttribute('disableRemotePlayback', 'true')
      ..setAttribute('x-webkit-airplay', 'deny')
      ..setAttribute('controlsList', 'nodownload noplaybackrate');

    _video = v;

    // Register the element for HtmlElementView
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) => v);

    // Expose the element globally by key so the button can find it reliably.
    _VideoRegistry.instance.register(widget.assetPath, v);
  }

  @override
  void dispose() {
    final v = _video;
    if (v != null) {
      v.pause();
      _VideoRegistry.instance.unregister(widget.assetPath, v);
    }
    _video = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}

/// A big tap-friendly fullscreen button placed BELOW the video so it doesn't
/// fight with scrubber / three-dot menu / cast UI.
class _FullscreenButton extends StatefulWidget {
  final String assetPath;
  const _FullscreenButton({required this.assetPath});

  @override
  State<_FullscreenButton> createState() => _FullscreenButtonState();
}

class _FullscreenButtonState extends State<_FullscreenButton> {
  StreamSubscription<html.Event>? _fsSub;

  @override
  void initState() {
    super.initState();

    // Unlock orientation on fullscreen exit (best-effort)
    _fsSub = html.document.onFullscreenChange.listen((_) {
      final isFs = html.document.fullscreenElement != null;
      if (!isFs) {
        _unlockOrientationBestEffort();
      }
    });
  }

  @override
  void dispose() {
    _fsSub?.cancel();
    super.dispose();
  }

  Future<void> _goFullscreen() async {
    final video = _VideoRegistry.instance.get(widget.assetPath);
    if (video == null) return;

    // Pause + play around fullscreen request sometimes stabilizes behavior on Android Chrome
    // (best-effort; safe if it fails).
    try {
      video.pause();
    } catch (_) {}

    // Request fullscreen on the VIDEO element (preferred)
    try {
      await video.requestFullscreen();
    } catch (_) {
      // Fallback: request fullscreen on document element
      try {
        await html.document.documentElement?.requestFullscreen();
      } catch (_) {}
    }

    // Try locking to landscape (works only in some browsers, and only after a user gesture)
    await _lockOrientationBestEffort();

    // Resume playback (optional)
    try {
      await video.play();
    } catch (_) {}
  }

  Future<void> _lockOrientationBestEffort() async {
    try {
      final orientation = html.window.screen?.orientation;
      if (orientation != null) {
        // Try the more specific mode first (some browsers prefer it)
        try {
          await orientation.lock('landscape-primary');
        } catch (_) {
          await orientation.lock('landscape');
        }
      }
    } catch (_) {
      // ignore
    }
  }

  void _unlockOrientationBestEffort() {
    try {
      final orientation = html.window.screen?.orientation;
      if (orientation != null) {
        orientation.unlock();
      }
    } catch (_) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton.icon(
        onPressed: _goFullscreen,
        icon: const Icon(Icons.open_in_full),
        label: const Text('Fullscreen'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

/// Simple registry so the fullscreen button can reliably find the correct
/// VideoElement instance without placing the button over HtmlElementView.
class _VideoRegistry {
  _VideoRegistry._();
  static final instance = _VideoRegistry._();

  final Map<String, html.VideoElement> _byKey = {};

  void register(String key, html.VideoElement el) {
    _byKey[key] = el;
  }

  void unregister(String key, html.VideoElement el) {
    if (_byKey[key] == el) _byKey.remove(key);
  }

  html.VideoElement? get(String key) => _byKey[key];
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
