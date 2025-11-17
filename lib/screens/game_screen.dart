import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ignite_hop/game/doodle_game.dart';
import 'package:ignite_hop/providers/game_provider.dart';
import 'package:ignite_hop/providers/settings_provider.dart';
import 'package:ignite_hop/theme.dart';
import 'package:flutter/services.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late DoodleGame game;
  bool showGameOver = false;

  @override
  void initState() {
    super.initState();
    game = DoodleGame();

    game.onScoreUpdate = (score) {
      context.read<GameProvider>().updateScore(score);
    };

    game.onGameOver = () {
      context.read<GameProvider>().endGame();
      setState(() => showGameOver = true);
    };

    game.onPlayerBounce = () {
      final haptics = context.read<SettingsProvider>().hapticsEnabled;
      if (haptics) {
        HapticFeedback.lightImpact();
      }
    };
  }

  void restartGame() {
    context.read<GameProvider>().resetGame();
    game.resetGame();
    setState(() => showGameOver = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: ScoreDisplay(),
          ),
          if (showGameOver) GameOverOverlay(onRestart: restartGame),
        ],
      ),
    );
  }
}

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.6),
                width: 2,
              ),
            ),
            child: Text(
              '${gameProvider.state.currentScore}',
              style: context.textStyles.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRestart;

  const GameOverOverlay({super.key, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Container(
          margin: AppSpacing.paddingXl,
          padding: AppSpacing.paddingXl,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.surface,
              ],
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
              width: 3,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.sports_score_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'GAME OVER',
                style: context.textStyles.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              Consumer<GameProvider>(
                builder: (context, gameProvider, _) {
                  final isNewHigh = gameProvider.state.currentScore ==
                      gameProvider.state.highScore &&
                      gameProvider.state.currentScore > 0;

                  return Column(
                    children: [
                      if (isNewHigh) ...[
                        Container(
                          padding: AppSpacing.paddingMd,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.celebration_rounded,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Text(
                                'NEW HIGH SCORE!',
                                style: context.textStyles.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg),
                      ],
                      ScoreCard(
                        label: 'YOUR SCORE',
                        score: gameProvider.state.currentScore,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(height: AppSpacing.md),
                      ScoreCard(
                        label: 'HIGH SCORE',
                        score: gameProvider.state.highScore,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GameButton(
                    onPressed: () => context.go('/'),
                    icon: Icons.home_rounded,
                    label: 'MENU',
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                  ),
                  SizedBox(width: AppSpacing.md),
                  GameButton(
                    onPressed: onRestart,
                    icon: Icons.refresh_rounded,
                    label: 'RESTART',
                    color: Theme.of(context).colorScheme.secondary,
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

class ScoreCard extends StatelessWidget {
  final String label;
  final int score;
  final Color color;

  const ScoreCard({
    super.key,
    required this.label,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: context.textStyles.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            '$score',
            style: context.textStyles.headlineLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class GameButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;

  const GameButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: context.textStyles.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
