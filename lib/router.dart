import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:oracle_d_asgard/screens/main_screen.dart';
import 'package:oracle_d_asgard/screens/quiz_screen.dart';
import 'package:oracle_d_asgard/screens/result_screen.dart';
import 'package:oracle_d_asgard/screens/profile_screen.dart';
import 'package:oracle_d_asgard/screens/about_screen.dart';
import 'package:oracle_d_asgard/screens/collectible_card_detail_page.dart';
import 'package:oracle_d_asgard/screens/games/qix/main_screen.dart'; // Import QixGameScreen
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/main_screen.dart'; // Import OrderTheScrollsGame
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/preliminary_screen.dart'; // Import OrderTheScrollsPreliminaryScreen
import 'package:oracle_d_asgard/screens/games/menu.dart'; // Import MenuPrincipal
import 'package:oracle_d_asgard/screens/games/asgard_wall/preliminary_screen.dart'; // Import AsgardWallGameScreen
import 'package:oracle_d_asgard/screens/games/puzzle/preliminary_screen.dart'; // Import PuzzlePreliminaryScreen
import 'package:oracle_d_asgard/screens/games/snake/preliminary_screen.dart'; // Import SnakePreliminaryScreen
import 'package:oracle_d_asgard/screens/games/qix/preliminary_screen.dart'; // Import QixPreliminaryScreen
import 'package:oracle_d_asgard/screens/games/word_search/preliminary_screen.dart'; // Import WordSearchPreliminaryScreen
import 'package:oracle_d_asgard/screens/games/minesweeper/preliminary_screen.dart'; // Import MinesweeperPreliminaryScreen
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/card_version.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MainScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'about',
          builder: (BuildContext context, GoRouterState state) {
            return const AboutScreen();
          },
        ),
        GoRoute(
          path: 'quiz',
          builder: (BuildContext context, GoRouterState state) {
            return const QuizScreen();
          },
        ),
        GoRoute(
          path: 'result',
          builder: (BuildContext context, GoRouterState state) {
            final deity = state.extra as String? ?? 'odin'; // Default deity
            return ResultScreen(deity: deity);
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileScreen();
          },
        ),
        GoRoute(
          path: 'card_detail',
          builder: (BuildContext context, GoRouterState state) {
            final card = state.extra as CollectibleCard? ??
              const CollectibleCard(
                id: 'default',
                title: 'Default Card',
                description: 'A default card',
                imagePath: 'default.png',
                tags: [],
                version: CardVersion.chibi,
              );
            return CollectibleCardDetailPage(card: card);
          },
        ),
        GoRoute(
          path: 'qix',
          builder: (BuildContext context, GoRouterState state) {
            return QixGameScreen();
          },
        ),
        GoRoute(
          path: 'order_the_scrolls_preliminary',
          builder: (BuildContext context, GoRouterState state) {
            return const OrderTheScrollsPreliminaryScreen();
          },
        ),
        GoRoute(
          path: 'order_the_scrolls',
          builder: (BuildContext context, GoRouterState state) {
            return const OrderTheScrollsGame();
          },
        ),
        GoRoute(
          path: 'games',
          builder: (BuildContext context, GoRouterState state) {
            return const MenuPrincipal();
          },
        ),
        GoRoute(
          path: 'asgard_wall_preliminary',
          builder: (BuildContext context, GoRouterState state) {
            return const AsgardWallGameScreen();
          },
        ),
        GoRoute(
          path: 'puzzle_preliminary',
          builder: (BuildContext context, GoRouterState state) {
            return const PuzzlePreliminaryScreen();
          },
        ),
        GoRoute(
          path: 'snake_preliminary',
          builder: (BuildContext context, GoRouterState state) {
            return const SnakePreliminaryScreen();
          },
        ),
        GoRoute(
          path: 'qix_preliminary',
          builder: (BuildContext context, GoRouterState state) {
            return const QixPreliminaryScreen();
          },
        ),
        GoRoute(
          path: 'word_search_preliminary',
          builder: (BuildContext context, GoRouterState state) {
            return const WordSearchPreliminaryScreen();
          },
        ),
        GoRoute(
          path: 'minesweeper_preliminary',
          builder: (BuildContext context, GoRouterState state) {
            return const MinesweeperPreliminaryScreen();
          },
        ),
      ],
    ),
  ],
);
