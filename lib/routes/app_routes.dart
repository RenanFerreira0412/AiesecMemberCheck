import 'package:aiesecmembercheck/screens/auth/auth_manager.dart';
import 'package:aiesecmembercheck/screens/external/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter routes = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthManager();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'authentication',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthScreen();
          },
        ),
      ],
    ),
  ],
);
