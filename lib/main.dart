import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/config/config.dart';

void main() async {
  await Environment.initEnvironment();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
