import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:indexed_stack/upper/upper.dart';
import 'package:indexed_stack/upper/lower/content/content.dart';
import 'package:indexed_stack/upper/lower/lower.dart';
import 'package:indexed_stack/main.dart';

final firstTabContentProvider = StreamProvider((ref) {
  final inputData = Stream.fromIterable([
    ['1', '2'],
    ['1', '2', '3'],
    ['1', '2'],
  ]);

  return streamDelayer(inputData, const Duration(seconds: 2));
});

final secondTabContentProvider = StreamProvider((ref) {
  final inputData = Stream.fromIterable([
    ['4', '5'],
    ['4', '5', '6'],
    ['4', '5'],
  ]);

  return streamDelayer(inputData, const Duration(seconds: 2));
});

Stream<T> streamDelayer<T>(Stream<T> inputStream, Duration delay) async* {
  await for (final val in inputStream) {
    yield val;
    await Future.delayed(delay);
  }
}

final appGoRouterProvider = Provider<GoRouter>(
  (ref) {
    final appNavigatorKey = ref.read(appNavigatorKeyProvider);

    final firstTabContentData = ref.watch(firstTabContentProvider).asData!;
    final secondTabContentData = ref.watch(secondTabContentProvider).asData!;

    final router = GoRouter(
      navigatorKey: appNavigatorKey,
      initialLocation: '/empty',
      routes: [
        // /
        ShellRoute(
          pageBuilder: (context, state, child) => NoTransitionPage(
            key: state.pageKey,
            child: child,
          ),
          routes: [
            StatefulShellRoute.indexedStack(
              pageBuilder: (context, state, child) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: MainPage(inner: child),
                );
              },
              branches: [
                getEmptyTab(''),
                getUpperTab('/a', firstTabContentData.value),
                getUpperTab('/b', secondTabContentData.value),
              ],
            ),
          ],
        ),
      ],
    );

    // ignore: invalid_use_of_visible_for_testing_member
    for (final route in router.configuration.debugKnownRoutes().split('\n')) {
      log(route);
    }

    ref.onDispose(router.dispose);

    return router;
  },
);

// Upper
StatefulShellBranch getUpperTab(String parentPath, List<String> tabContent) =>
    StatefulShellBranch(
      routes: [
        StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, child) {
            return NoTransitionPage(
              key: state.pageKey,
              child: UpperTab(
                inner: child,
                parentPath: parentPath,
                tabContent: tabContent,
              ),
            );
          },
          branches: [
            getEmptyTab('$parentPath/upper'),
            for (final content in tabContent)
              getLowerTab('$parentPath/upper/$content'),
          ],
        ),
      ],
    );

// Lower
StatefulShellBranch getLowerTab(String parentPath) => StatefulShellBranch(
      routes: [
        StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, child) {
            return NoTransitionPage(
              key: state.pageKey,
              child: LowerTab(inner: child),
            );
          },
          branches: [
            getContentTab('$parentPath/lower'),
          ],
        ),
      ],
    );

StatefulShellBranch getContentTab(String parentPath) => StatefulShellBranch(
      routes: [
        getContentPage(parentPath),
      ],
    );

GoRoute getContentPage(String parentPath) => GoRoute(
      path: '$parentPath/content',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: ValueKey('$parentPath/content'),
          transitionsBuilder: getFadeThroughTransition,
          child: ContentPage(
            url: state.uri.toString(),
          ),
        );
      },
    );

StatefulShellBranch getEmptyTab(String parentPath) => StatefulShellBranch(
      routes: [
        getEmptyPage(parentPath),
      ],
    );

GoRoute getEmptyPage(String parentPath) => GoRoute(
      path: '$parentPath/empty',
      pageBuilder: (context, state) {
        return const CustomTransitionPage(
          transitionsBuilder: getFadeThroughTransition,
          child: Text('empty'),
        );
      },
    );

FadeThroughTransition getFadeThroughTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeThroughTransition(
    animation: animation,
    secondaryAnimation: secondaryAnimation,
    child: child,
  );
}
