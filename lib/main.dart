import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:indexed_stack/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final appNavigatorKeyProvider = Provider((ref) => GlobalKey<NavigatorState>());

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: ref.watch(appGoRouterProvider),
    );
  }
}

class MainPage extends HookConsumerWidget {
  const MainPage({
    super.key,
    required this.inner,
  });

  final StatefulNavigationShell inner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('title'),
      ),
      body: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Main'),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: () => inner.goBranch(0),
                  child: const Text('Close'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: () => inner.goBranch(1),
                  child: const Text('A'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: () => inner.goBranch(2),
                  child: const Text('B'),
                ),
              ),
            ],
          ),
          Center(
            child: SizedBox(
              width: 932,
              height: 932,
              child: inner,
            ),
          ),
        ],
      ),
    );
  }
}
