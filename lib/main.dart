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
          constraints: const BoxConstraints(maxWidth: 1100),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            children: [
              const Text(
                'Fit Quest',
                style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              const Text(
                'A social, gamified fitness tracker. Log workouts, share progress, and level up.',
                style: TextStyle(
                  fontSize: 18,
                  height: 1.4,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add Play Store link when ready
                    },
                    child: const Text('Download on Google Play'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.go('/privacy'),
                    child: const Text('Privacy Policy'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Support: support@fitquest.space',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 40),
              const _SectionHeader(
                title: 'See Fit Quest in action',
                subtitle: 'Two short clips showing the core experience.',
              ),
              const SizedBox(height: 20),
              const PromoVideoCard(
                title: 'Overview',
                description: 'Account setup, friends, sharing, and importing.',
                assetPath: 'assets/videos/promo1.mp4',
              ),
              const SizedBox(height: 24),
              const PromoVideoCard(
                title: 'Exercise flow',
                description: 'History, suggested sets, and form video sharing.',
                assetPath: 'assets/videos/promo2.mp4',
              ),
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 12),
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
        borderRadius: BorderRadius.circular(16),
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
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF4B5563),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: kIsWeb ? _NativeHtmlVideo(assetPath: assetPath) : const SizedBox.shrink(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tap Play to open fullscreen automatically. Closing fullscreen stops the video.',
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
  StreamSubscription<html.Event>? _onPlaySub;
  StreamSubscription<html.Event>? _onPauseSub;
  StreamSubscription<html.Event>? _onEndedSub;

  Timer? _fullscreenPoller;
  bool _requestingFullscreen = false;
  bool _wasFullscreen = false; // we set true once fullscreen is entered successfully

  @override
  void initState() {
    super.initState();

    _viewType = 'fq-video-${widget.assetPath}-${DateTime.now().microsecondsSinceEpoch}';

    // Flutter web serves assets under /assets/...
    // If widget.assetPath is "assets/videos/promo1.mp4", served URL becomes:
    //   /assets/assets/videos/promo1.mp4
    final src = 'assets/${widget.assetPath}';

    final video = html.VideoElement()
      ..src = src
      ..controls = true
      ..preload = 'metadata'
      ..autoplay = false
      ..loop = false
      ..muted = false
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'contain'
      ..style.backgroundColor = 'black'
      ..setAttribute('playsinline', 'true')
      ..setAttribute('webkit-playsinline', 'true')
      ..setAttribute('controlsList', 'nodownload noplaybackrate');

    _video = video;

    // When user hits Play, attempt to enter fullscreen immediately (best-effort).
    _onPlaySub = video.onPlay.listen((_) async {
      _startFullscreenPolling();

      // If already in fullscreen, don't request again.
      if (_isInFullscreen()) return;

      if (_requestingFullscreen) return;
      _requestingFullscreen = true;

      try {
        await video.requestFullscreen();
        _wasFullscreen = true;
      } catch (_) {
        // Browser may block programmatic fullscreen; video will play inline.
        _wasFullscreen = false;
      } finally {
        _requestingFullscreen = false;
      }
    });

    // If user pauses, stop polling (no need to keep checking).
    _onPauseSub = video.onPause.listen((_) {
      _stopFullscreenPolling();
      _wasFullscreen = false;
    });

    // If video ends, stop polling and reset.
    _onEndedSub = video.onEnded.listen((_) {
      _stopFullscreenPolling();
      _wasFullscreen = false;
      try {
        video.currentTime = 0;
      } catch (_) {}
    });

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) => video,
    );
  }

  bool _isInFullscreen() {
    // FullscreenElement is the most standard check; may be null on some implementations,
    // but our polling still catches the exit condition once it *was* fullscreen.
    return html.document.fullscreenElement != null;
  }

  void _startFullscreenPolling() {
    _fullscreenPoller ??= Timer.periodic(const Duration(milliseconds: 200), (_) {
      final v = _video;
      if (v == null) return;

      // If we successfully entered fullscreen earlier and now fullscreen is gone, stop video.
      if (_wasFullscreen && !_isInFullscreen()) {
        try {
          v.pause();
          v.currentTime = 0;
        } catch (_) {}
        _wasFullscreen = false;
        _stopFullscreenPolling();
      }
    });
  }

  void _stopFullscreenPolling() {
    _fullscreenPoller?.cancel();
    _fullscreenPoller = null;
  }

  @override
  void dispose() {
    _stopFullscreenPolling();
    _onPlaySub?.cancel();
    _onPauseSub?.cancel();
    _onEndedSub?.cancel();
    try {
      _video?.pause();
    } catch (_) {}
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
        Text(subtitle, style: const TextStyle(color: Color(0xFF4B5563))),
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
