import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:indexed_stack/upper/a.dart';
import 'package:indexed_stack/upper/b.dart';
import 'package:indexed_stack/upper/lower/content/content.dart';
import 'package:indexed_stack/upper/lower/first.dart';
import 'package:indexed_stack/upper/lower/second.dart';
import 'package:indexed_stack/main.dart';

final appGoRouterProvider = Provider<GoRouter>(
  (ref) {
    final appNavigatorKey = ref.read(appNavigatorKeyProvider);

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
                getATab(),
                getBTab(),
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

// /a
StatefulShellBranch getATab() => StatefulShellBranch(
      routes: [
        StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, child) {
            return NoTransitionPage(
              key: state.pageKey,
              child: ATab(inner: child),
            );
          },
          branches: [
            getEmptyTab('/a'),
            getFirstTab('/a'),
            getSecondTab('/a'),
          ],
        ),
      ],
    );

// /b
StatefulShellBranch getBTab() => StatefulShellBranch(
      routes: [
        StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, child) {
            return NoTransitionPage(
              key: state.pageKey,
              child: BTab(inner: child),
            );
          },
          branches: [
            getEmptyTab('/b'),
            getFirstTab('/b'),
            getSecondTab('/b'),
          ],
        ),
      ],
    );

// /first
StatefulShellBranch getFirstTab(String parentPath) => StatefulShellBranch(
      routes: [
        StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, child) {
            return NoTransitionPage(
              key: state.pageKey,
              child: FirstTab(inner: child),
            );
          },
          branches: [
            getContentTab('$parentPath/first'),
          ],
        ),
      ],
    );

// /second
StatefulShellBranch getSecondTab(String parentPath) => StatefulShellBranch(
      routes: [
        StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, child) {
            return NoTransitionPage(
              key: state.pageKey,
              child: SecondTab(inner: child),
            );
          },
          branches: [
            getContentTab('$parentPath/second'),
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
