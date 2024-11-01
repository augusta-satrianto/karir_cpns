import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:karir_cpns_app/dashboard_page.dart';
import 'package:karir_cpns_app/do_exam_page.dart';
import 'package:karir_cpns_app/ebook_view_page.dart';
import 'package:karir_cpns_app/landing_page.dart';
import 'package:karir_cpns_app/login_page.dart';
import 'package:karir_cpns_app/ebook_page.dart';
import 'package:karir_cpns_app/materi_page.dart';
import 'package:karir_cpns_app/prepare_exam_page.dart';
import 'package:karir_cpns_app/register_page.dart';
import 'package:karir_cpns_app/pages/tryout/tryout_page.dart';
import 'package:karir_cpns_app/video_page.dart';
import 'package:karir_cpns_app/webinar_page.dart';
import 'package:karir_cpns_app/webinar_view_page.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<int>('timer');
  await Hive.openBox('credentialsBox');
  setPathUrlStrategy();
  runApp(const MyApp());
}
// flutter run -d chrome --web-renderer html --web-port 5000

bool isLoggedIn = true;

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'landing',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
      redirect: (context, state) {
        if (!isLoggedIn) {
          return '/login';
        }
        return '/dashboard';
      },
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
      redirect: (context, state) {
        if (!isLoggedIn) {
          return '/login';
        }
        return null;
      },
      routes: [
        // Materi
        GoRoute(
          path: 'user/learning-material',
          builder: (context, state) => const MateriPage(),
          routes: [
            GoRoute(
              path: 'document/list',
              builder: (context, state) => const EbookPage(),
            ),
            GoRoute(
              path: 'document/show',
              builder: (context, state) => const EbookViewPage(),
            ),
            GoRoute(
              path: 'video/list',
              builder: (context, state) => const VideoPage(),
            ),
          ],
        ),

        // Tryout
        GoRoute(
          path: 'user/tryout/list',
          builder: (context, state) => const TryoutPage(),
        ),
        GoRoute(
          path: 'user/tryout/prepare-exam/skd-cpns/:level/:examId',
          builder: (context, state) {
            final level = state.pathParameters['level']!;
            final examId = state.pathParameters['examId']!;
            return PrepareExamPage(level: level, examId: examId);
          },
        ),
        GoRoute(
          path: 'user/tryout/do-exam/skd-cpns/:level/:examId',
          builder: (context, state) {
            final level = state.pathParameters['level']!;
            final examId = state.pathParameters['examId']!;
            return DoExamPage(level: level, examId: examId);
          },
        ),

        // Webinar
        GoRoute(
            path: 'user/webinar',
            builder: (context, state) => const WebinarPage(),
            routes: [
              GoRoute(
                path: ':webinarId',
                builder: (context, state) {
                  final webinarId = state.pathParameters['webinarId']!;
                  return WebinarViewPage(
                    webinarId: webinarId,
                  );
                },
              ),
            ]),
      ],
    ),
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(
      child: Text('Page not found'),
    ),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'KARIR CPNS',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      ),
      routerConfig: _router,
    );
  }
}
