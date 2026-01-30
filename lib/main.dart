import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

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
      theme: ThemeData(useMaterial3: true),
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
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fit Quest',
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'A social, gamified fitness tracker. Log workouts, share progress, and level up.',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 28),

                Wrap(
                  spacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Download on Google Play'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        context.go('/privacy');
                      },
                      child: const Text('Privacy Policy'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Text(
                  'Support: support@fitquest.space',
                  style: TextStyle(color: Colors.black54),
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
