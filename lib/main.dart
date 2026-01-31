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

class PromoVideoCard extends StatefulWidget {
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
  State<PromoVideoCard> createState() => _PromoVideoCardState();
}

class _PromoVideoCardState extends State<PromoVideoCard> {
  html.VideoElement? _video; // the inline video element

  void _openOverlay() {
    final v = _video;
    if (v == null) return;

    // Pause inline video so we don't get double-audio
    try {
      v.pause();
    } catch (_) {}

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close video',
      barrierColor: const Color(0xDD000000),
      transitionDuration: const Duration(milliseconds: 160),
      pageBuilder: (ctx, a1, a2) {
        return _VideoOverlay(
          original: v,
          title: widget.title,
        );
      },
      transitionBuilder: (ctx, anim, sec, child) {
        final t = Curves.easeOut.transform(anim.value);
        return Transform.scale(
          scale: 0.98 + (0.02 * t),
          child: Opacity(opacity: t, child: child),
        );
      },
    );
  }

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
          Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(
            widget.description,
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
                    ? _NativeHtmlInlineVideo(
                        assetPath: widget.assetPath,
                        onCreated: (el) => _video = el,
                      )
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

          // Tap-safe: button is BELOW the video (no fighting scrubber / cast / 3-dots)
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 44,
              child: OutlinedButton.icon(
                onPressed: kIsWeb ? _openOverlay : null,
                icon: const Icon(Icons.open_in_full),
                label: const Text('Fullscreen'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Inline <video> element that behaves nicely on mobile.
/// NOTE: This is NOT browser fullscreen. Fullscreen is handled by our overlay.
class _NativeHtmlInlineVideo extends StatefulWidget {
  final String assetPath;
  final void Function(html.VideoElement el) onCreated;

  const _NativeHtmlInlineVideo({
    required this.assetPath,
    required this.onCreated,
  });

  @override
  State<_NativeHtmlInlineVideo> createState() => _NativeHtmlInlineVideoState();
}

class _NativeHtmlInlineVideoState extends State<_NativeHtmlInlineVideo> {
  late final String _viewType;
  html.VideoElement? _video;

  @override
  void initState() {
    super.initState();

    _viewType = 'fq-inline-${widget.assetPath}-${DateTime.now().microsecondsSinceEpoch}';

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
      // Reduce cast prompts where supported:
      ..setAttribute('disableRemotePlayback', 'true')
      ..setAttribute('x-webkit-airplay', 'deny')
      ..setAttribute('controlsList', 'nodownload noplaybackrate');

    _video = v;
    widget.onCreated(v);

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) => v);
  }

  @override
  void dispose() {
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

/// Full-screen modal overlay that stays inside the page.
/// This avoids Android Chrome's true fullscreen rotation weirdness.
class _VideoOverlay extends StatefulWidget {
  final html.VideoElement original;
  final String title;

  const _VideoOverlay({
    required this.original,
    required this.title,
  });

  @override
  State<_VideoOverlay> createState() => _VideoOverlayState();
}

class _VideoOverlayState extends State<_VideoOverlay> {
  late final String _viewType;
  html.VideoElement? _overlayVideo;

  @override
  void initState() {
    super.initState();

    _viewType = 'fq-overlay-${DateTime.now().microsecondsSinceEpoch}';

    // Clone a new <video> element pointing at the same source.
    // This avoids weird state carryover from inline controls.
    final src = widget.original.currentSrc.isNotEmpty ? widget.original.currentSrc : widget.original.src;

    final v = html.VideoElement()
      ..src = src
      ..controls = true
      ..preload = 'auto'
      ..autoplay = true
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
      ..setAttribute('disableRemotePlayback', 'true')
      ..setAttribute('x-webkit-airplay', 'deny')
      ..setAttribute('controlsList', 'nodownload noplaybackrate');

    _overlayVideo = v;
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) => v);
  }

  @override
  void dispose() {
    try {
      _overlayVideo?.pause();
    } catch (_) {}
    _overlayVideo = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Backdrop tap to close
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),

            // Centered video container
            Positioned.fill(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Top bar
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close, color: Colors.white),
                              tooltip: 'Close',
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Big video area
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: Colors.black,
                              child: HtmlElementView(viewType: _viewType),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        const Text(
                          'Tip: Rotate your phone to landscape for the biggest view.',
                          style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
