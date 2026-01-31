import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:video_player/video_player.dart';

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
          constraints: const BoxConstraints(maxWidth: 980),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            children: [
              const SizedBox(height: 8),
              const Text(
                'Fit Quest',
                style: TextStyle(fontSize: 44, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              const Text(
                'A social, gamified fitness tracker. Log workouts, share progress, and level up.',
                style: TextStyle(fontSize: 18, height: 1.4, color: Color(0xFF374151)),
              ),
              const SizedBox(height: 22),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: replace once your Play Store listing exists
                      // ex: launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=...'));
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

              const SizedBox(height: 34),
              const _SectionHeader(
                title: 'See Fit Quest in action',
                subtitle: 'Two quick clips that show the vibe and the core flows.',
              ),
              const SizedBox(height: 14),

              // Responsive grid-ish layout: stacks on narrow screens, 2-column on wider.
              LayoutBuilder(
                builder: (context, c) {
                  final isWide = c.maxWidth >= 820;
                  if (!isWide) {
                    return const Column(
                      children: [
                        PromoVideoCard(
                          title: 'Promo video #1',
                          description: 'Your 54-second overview: social + tracking + sharing.',
                          assetPath: 'assets/videos/promo1.mp4',
                        ),
                        SizedBox(height: 16),
                        PromoVideoCard(
                          title: 'Promo video #2',
                          description: 'Your 1:20 deep dive: history + suggested sets + form video.',
                          assetPath: 'assets/videos/promo2.mp4',
                        ),
                      ],
                    );
                  }

                  return const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PromoVideoCard(
                          title: 'Promo video #1',
                          description: 'Your 54-second overview: social + tracking + sharing.',
                          assetPath: 'assets/videos/promo1.mp4',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: PromoVideoCard(
                          title: 'Promo video #2',
                          description: 'Your 1:20 deep dive: history + suggested sets + form video.',
                          assetPath: 'assets/videos/promo2.mp4',
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),
              const Divider(height: 1),
              const SizedBox(height: 18),
              Row(
                children: [
                  TextButton(
                    onPressed: () => context.go('/privacy'),
                    child: const Text('Privacy Policy'),
                  ),
                  const SizedBox(width: 8),
                  const Text('•', style: TextStyle(color: Colors.black38)),
                  const SizedBox(width: 8),
                  Text('© ${_Year.now} Fit Quest', style: TextStyle(color: Colors.black54)),
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
  late final VideoPlayerController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..setLooping(true)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _ready = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            widget.description,
            style: const TextStyle(color: Color(0xFF4B5563), height: 1.35),
          ),
          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: const Color(0xFF0B1220),
                child: !_ready
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          VideoPlayer(_controller),
                          _ControlsBar(controller: _controller),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlsBar extends StatefulWidget {
  final VideoPlayerController controller;
  const _ControlsBar({required this.controller});

  @override
  State<_ControlsBar> createState() => _ControlsBarState();
}

class _ControlsBarState extends State<_ControlsBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_tick);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_tick);
    super.dispose();
  }

  void _tick() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final isPlaying = c.value.isPlaying;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: const Color(0x66000000),
      child: Row(
        children: [
          IconButton(
            onPressed: () => isPlaying ? c.pause() : c.play(),
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
            tooltip: isPlaying ? 'Pause' : 'Play',
          ),
          Expanded(
            child: VideoProgressIndicator(
              c,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.white,
                bufferedColor: Color(0x99FFFFFF),
                backgroundColor: Color(0x33FFFFFF),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _fmt(c.value.position) + ' / ' + _fmt(c.value.duration),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _fmt(Duration d) {
    final s = d.inSeconds;
    final m = (s ~/ 60).toString().padLeft(1, '0');
    final r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
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
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(color: Color(0xFF4B5563), height: 1.35)),
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

class _Year {
  static int get now => DateTime.now().year;
}
