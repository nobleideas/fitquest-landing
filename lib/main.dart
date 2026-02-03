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

              /// 🔹 BUTTONS
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Download on Google Play'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.go('/privacy'),
                    child: const Text('Privacy Policy'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      html.window.open(
                        'https://supabase-auth-sigma.vercel.app/',
                        '_blank',
                      );
                    },
                    child: const Text('Mobile Web Version'),
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
        Text(subtitle, style: const TextStyle(color: Color(0xFF4B5563))),
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
