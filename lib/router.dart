import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:indexed_stack/upper/upper.dart';
import 'package:indexed_stack/upper/lower/content/content.dart';
import 'package:indexed_stack/upper/lower/lower.dart';
import 'package:indexed_stack/main.dart';

final myConfig = GoRouterConfigNotifier(
  generateRoutingConfig(['1'], ['1']),
);

class GoRouterConfigNotifier extends ValueNotifier<RoutingConfig> {
  GoRouterConfigNotifier(super.value);

  void updateBranches(
    List<String> firstTabContentData,
    List<String> secondTabContentData,
  ) {
    value = generateRoutingConfig(firstTabContentData, secondTabContentData);
  }
}

RoutingConfig generateRoutingConfig(
  List<String> firstTabContentData,
  List<String> secondTabContentData,
) {
  return RoutingConfig(
    routes: [
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
              getUpperTab('/a', firstTabContentData),
              getUpperTab('/b', secondTabContentData),
            ],
          ),
        ],
      ),
    ],
  );
}

final appGoRouterProvider = Provider<GoRouter>(
  (ref) {
    final router = GoRouter.routingConfig(
      routingConfig: myConfig,
      initialLocation: '/empty',
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
