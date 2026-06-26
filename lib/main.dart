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
        GoRoute(path: '/delete', builder: (_, __) => const DeleteAccountPage()),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF111827),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      ),
    );
  }
}

void _openDeletionEmail() {
  // Opens the user's email client with a prefilled deletion request.
  final subject = Uri.encodeComponent('Fit Quest Account Deletion Request');
  final body = Uri.encodeComponent(
    'Please delete my Fit Quest account and all associated data.\n\n'
    'Account email: \n'
    'Additional details (optional): \n',
  );

  final mailto = 'mailto:support@fitquest.space?subject=$subject&body=$body';

  try {
    html.window.open(mailto, '_self');
  } catch (_) {
    // If mailto fails for any reason, still give them a fallback they can copy.
    html.window.alert('Please email support@fitquest.space to request deletion.');
  }
}

void _openExternal(String url) {
  html.window.open(url, '_blank');
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const githubUrl = 'https://github.com/nobleideas/supabase-auth';
  static const appUrl = 'https://supabase-auth-sigma.vercel.app/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            children: [
              const _HeroSection(
                githubUrl: githubUrl,
                appUrl: appUrl,
              ),
              const SizedBox(height: 28),

              const _StatsStrip(),
              const SizedBox(height: 40),

              const _SectionHeader(
                title: 'What Fit Quest solves',
                subtitle:
                    'Fit Quest helps lifters track progressive overload, reduce workout planning fatigue, and share useful training content with friends.',
              ),
              const SizedBox(height: 18),
              const _FeatureGrid(),
              const SizedBox(height: 44),

              const _SectionHeader(
                title: 'See Fit Quest in action',
                subtitle:
                    'Short clips showing the core product experience and the engineering work behind it.',
              ),
              const SizedBox(height: 20),
              const PromoVideoCard(
                title: 'Overview',
                description:
                    'Account setup, friends, sharing, and importing equipment and exercises from other users.',
                assetPath: 'assets/videos/promo1.mp4',
              ),
              const SizedBox(height: 24),
              const PromoVideoCard(
                title: 'Exercise flow',
                description:
                    'Exercise history, suggested sets, volume tracking, and form video sharing.',
                assetPath: 'assets/videos/promo2.mp4',
              ),
              const SizedBox(height: 24),
              const PromoVideoCard(
                title: 'Auto-rotated workouts',
                description:
                    'Suggested workouts that rotate exercises evenly so users can train their body instead of overthinking the plan.',
                assetPath: 'assets/videos/promo3.mp4',
              ),
              const SizedBox(height: 44),

              const _SectionHeader(
                title: 'Built by one developer',
                subtitle:
                    'Fit Quest is a full-stack Flutter project designed, built, debugged, and deployed from concept to production.',
              ),
              const SizedBox(height: 18),
              const _EngineeringSection(),
              const SizedBox(height: 44),

              const _SectionHeader(
                title: 'Technology stack',
                subtitle:
                    'The project combines mobile/web development, cloud services, local storage, media support, and production deployment.',
              ),
              const SizedBox(height: 18),
              const _TechStack(),
              const SizedBox(height: 44),

              const _SectionHeader(
                title: 'Engineering notes',
                subtitle:
                    'A few of the technical problems and product decisions behind the app.',
              ),
              const SizedBox(height: 18),
              const _NotesSection(),
              const SizedBox(height: 44),

              const _CalloutCard(),
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
                  TextButton(
                    onPressed: () => context.go('/delete'),
                    child: const Text('Delete Account'),
                  ),
                  const Spacer(),
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

class _HeroSection extends StatelessWidget {
  final String githubUrl;
  final String appUrl;

  const _HeroSection({
    required this.githubUrl,
    required this.appUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 22,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 850;

          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fit Quest',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              const Text(
                'Track progressive overload. Share exercises and equipment. Let the app suggest balanced workouts so you can train your body, not your brain.',
                style: TextStyle(
                  fontSize: 20,
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
                    onPressed: () {},
                    child: const Text('Download on iOS App Store'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Download on Google Play'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => _openExternal(appUrl),
                    child: const Text('Open Web App'),
                  ),
                  OutlinedButton(
                    onPressed: () => _openExternal(githubUrl),
                    child: const Text('View GitHub'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.go('/privacy'),
                    child: const Text('Privacy Policy'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.go('/delete'),
                    child: const Text('Delete Account'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Support: support@fitquest.space',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          );

          const sideCard = _HeroSideCard();

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: content),
                const SizedBox(width: 28),
                const Expanded(flex: 2, child: sideCard),
              ],
            );
          }

          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroTextMobile(),
              SizedBox(height: 24),
              _HeroSideCard(),
            ],
          );
        },
      ),
    );
  }
}

class _HeroTextMobile extends StatelessWidget {
  const _HeroTextMobile();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fit Quest',
          style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        const Text(
          'Track progressive overload. Share exercises and equipment. Let the app suggest balanced workouts so you can train your body, not your brain.',
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
              onPressed: () {},
              child: const Text('Download on iOS App Store'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Download on Google Play'),
            ),
            FilledButton.tonal(
              onPressed: () => _openExternal(HomePage.appUrl),
              child: const Text('Open Web App'),
            ),
            OutlinedButton(
              onPressed: () => _openExternal(HomePage.githubUrl),
              child: const Text('View GitHub'),
            ),
            OutlinedButton(
              onPressed: () => context.go('/privacy'),
              child: const Text('Privacy Policy'),
            ),
            OutlinedButton(
              onPressed: () => context.go('/delete'),
              child: const Text('Delete Account'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Support: support@fitquest.space',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}

class _HeroSideCard extends StatelessWidget {
  const _HeroSideCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Built as a real product, not a tutorial.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          SizedBox(height: 14),
          Text(
            'Fit Quest demonstrates product design, Flutter development, Supabase integration, workout tracking logic, media support, social features, and production deployment.',
            style: TextStyle(
              color: Color(0xFFD1D5DB),
              height: 1.45,
            ),
          ),
          SizedBox(height: 18),
          _MiniBadge(label: 'Flutter Web + Mobile'),
          SizedBox(height: 8),
          _MiniBadge(label: 'Supabase Backend'),
          SizedBox(height: 8),
          _MiniBadge(label: '9,000+ lines of Dart'),
          SizedBox(height: 8),
          _MiniBadge(label: '29 Dart source files'),
        ],
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;

  const _MiniBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF374151)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _StatCard(value: '9,000+', label: 'lines of Dart code'),
        _StatCard(value: '29', label: 'Dart source files'),
        _StatCard(value: '3', label: 'core product systems'),
        _StatCard(value: '1', label: 'sole developer'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Color(0xFF4B5563))),
        ],
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _FeatureCard(
          icon: Icons.trending_up,
          title: 'Progressive overload',
          description:
              'Track sets, reps, and training volume so users can intentionally increase workload over time.',
        ),
        _FeatureCard(
          icon: Icons.auto_awesome,
          title: 'Auto-rotated workouts',
          description:
              'Generate balanced workout suggestions by rotating exercises evenly and reducing decision fatigue.',
        ),
        _FeatureCard(
          icon: Icons.group_outlined,
          title: 'Friend-based sharing',
          description:
              'Add friends and import shared equipment and exercises to build a better workout library.',
        ),
        _FeatureCard(
          icon: Icons.video_library_outlined,
          title: 'Form video support',
          description:
              'Upload exercise form videos to connect workout tracking with technique improvement.',
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: const Color(0xFF111827)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Color(0xFF4B5563), height: 1.4),
          ),
        ],
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
        ],
      ),
    );
  }
}

class _EngineeringSection extends StatelessWidget {
  const _EngineeringSection();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _EngineeringCard(
          title: 'Product architecture',
          description:
              'Structured the app around account creation, authentication, workout tracking, exercise libraries, equipment libraries, friend connections, and media flows.',
        ),
        _EngineeringCard(
          title: 'Workout logic',
          description:
              'Built tracking around sets, reps, and volume, then extended the experience with suggested workout rotation.',
        ),
        _EngineeringCard(
          title: 'Production deployment',
          description:
              'Researched and resolved Flutter web deployment configuration issues to publish the application to production hosting.',
        ),
      ],
    );
  }
}

class _EngineeringCard extends StatelessWidget {
  final String title;
  final String description;

  const _EngineeringCard({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Color(0xFFD1D5DB), height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _TechStack extends StatelessWidget {
  const _TechStack();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _TechChip(label: 'Flutter'),
        _TechChip(label: 'Dart'),
        _TechChip(label: 'Supabase'),
        _TechChip(label: 'Firebase Core'),
        _TechChip(label: 'Firebase Messaging setup'),
        _TechChip(label: 'SQLite'),
        _TechChip(label: 'Provider'),
        _TechChip(label: 'Image Picker'),
        _TechChip(label: 'Video Player'),
        _TechChip(label: 'QR / Barcode scanning'),
        _TechChip(label: 'Flutter Web'),
        _TechChip(label: 'Vercel deployment'),
        _TechChip(label: 'GitHub'),
      ],
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;

  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFE5E7EB)),
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _NoteTile(
          title: 'Why volume matters',
          body:
              'Fit Quest was built around the idea that users should be able to see training volume clearly and progressively add workload over time.',
        ),
        SizedBox(height: 12),
        _NoteTile(
          title: 'Why suggested workouts matter',
          body:
              'The auto-rotated workout flow reduces mental effort in the gym by suggesting balanced workouts instead of making users plan every session from scratch.',
        ),
        SizedBox(height: 12),
        _NoteTile(
          title: 'Why sharing matters',
          body:
              'Friends can share and import exercises and equipment, turning individual workout setup into a reusable community resource.',
        ),
      ],
    );
  }
}

class _NoteTile extends StatelessWidget {
  final String title;
  final String body;

  const _NoteTile({
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(color: Color(0xFF4B5563), height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _CalloutCard extends StatelessWidget {
  const _CalloutCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: const Text(
        'Fit Quest is still evolving. Push notifications and additional production features are planned as development continues.',
        style: TextStyle(
          color: Color(0xFF1E3A8A),
          fontWeight: FontWeight.w700,
          height: 1.45,
        ),
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
  Timer? _poller;
  bool _wasFullscreen = false;
  bool _requesting = false;

  @override
  void initState() {
    super.initState();

    _viewType = 'fq-video-${widget.assetPath}-${DateTime.now().microsecondsSinceEpoch}';
    final src = 'assets/${widget.assetPath}';

    final video = html.VideoElement()
      ..src = src
      ..controls = true
      ..preload = 'metadata'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'contain'
      ..setAttribute('playsinline', 'true')
      ..setAttribute('webkit-playsinline', 'true');

    _video = video;

    video.onPlay.listen((_) async {
      _startPolling();
      if (_requesting) return;
      _requesting = true;
      try {
        await video.requestFullscreen();
        _wasFullscreen = true;
      } catch (_) {
        _wasFullscreen = false;
      } finally {
        _requesting = false;
      }
    });

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) => video);
  }

  void _startPolling() {
    _poller ??= Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (_wasFullscreen && html.document.fullscreenElement == null) {
        try {
          _video?.pause();
          _video?.currentTime = 0;
        } catch (_) {}
        _wasFullscreen = false;
        _poller?.cancel();
        _poller = null;
      }
    });
  }

  @override
  void dispose() {
    _poller?.cancel();
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
        Text(subtitle, style: const TextStyle(color: Color(0xFF4B5563), height: 1.4)),
      ],
    );
  }
}

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Account')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Request Account & Data Deletion',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                const Text(
                  'You may request deletion of your Fit Quest account and all associated data at any time.',
                  style: TextStyle(height: 1.55, color: Color(0xFF374151)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'To request deletion, email support and include the email address associated with your Fit Quest account.',
                  style: TextStyle(height: 1.55, color: Color(0xFF374151)),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _openDeletionEmail,
                      icon: const Icon(Icons.email_outlined),
                      label: const Text('Email support@fitquest.space'),
                    ),
                    OutlinedButton(
                      onPressed: () => context.go('/privacy'),
                      child: const Text('View Privacy Policy'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'If the email button does not open your email client, please email: support@fitquest.space',
                  style: TextStyle(color: Colors.black54, height: 1.4),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text('← Back to home'),
                ),
              ],
            ),
          ),
        ),
      ),
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

Fit Quest ("we", "our", or "us") provides a social, gamified fitness tracking application. 
This Privacy Policy explains how we collect, use, and protect your information.

Information We Collect
• Account information such as email address and username
• Workout and fitness data including exercises, sets, reps, weights, and timestamps
• Content you upload such as exercise form videos
• Social data such as friends, shared workouts, and interactions you choose to enable
• Basic diagnostics and usage data for reliability, debugging, and support

How We Use Your Information
• To provide and maintain core app functionality
• To personalize your experience and generate workout suggestions
• To enable social features you choose to use
• To improve performance, stability, and product features
• To respond to support requests and user feedback

Data Storage and Security
• Data is stored and processed using trusted third-party infrastructure providers, including Supabase
• Reasonable technical and organizational safeguards are used to protect your data
• No system can be guaranteed 100% secure, but we strive to follow industry best practices

Data Sharing
• We do not sell your personal data
• Data is shared only as necessary to operate the service or when required by law
• Content you choose to share may be visible to other users depending on the nature of the feature you are using (for example, the friends social feature).

Data Retention
• Your data is retained while your account is active
• You may request account and data deletion by contacting support@fitquest.space

Children’s Privacy
• Fit Quest is not intended for children under 13
• We do not knowingly collect personal information from children

Your Rights
• You may access, update, or delete your account information
• You may request clarification on how your data is used
• You may stop using certain features at any time by choosing not to engage with them or by deleting your account.

Changes to This Policy
• This policy may be updated from time to time
• Changes will be reflected on this page with an updated revision date

Contact
support@fitquest.space
''',
            style: TextStyle(height: 1.55),
          ),
        ),
      ),
    );
  }
}
