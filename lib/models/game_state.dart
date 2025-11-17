class GameState {
  final int currentScore;
  final int highScore;
  final bool isPlaying;
  final bool isGameOver;

  GameState({
    this.currentScore = 0,
    this.highScore = 0,
    this.isPlaying = false,
    this.isGameOver = false,
  });

  GameState copyWith({
    int? currentScore,
    int? highScore,
    bool? isPlaying,
    bool? isGameOver,
  }) =>
      GameState(
        currentScore: currentScore ?? this.currentScore,
        highScore: highScore ?? this.highScore,
        isPlaying: isPlaying ?? this.isPlaying,
        isGameOver: isGameOver ?? this.isGameOver,
      );

  Map<String, dynamic> toJson() => {
        'currentScore': currentScore,
        'highScore': highScore,
        'isPlaying': isPlaying,
        'isGameOver': isGameOver,
      };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
        currentScore: json['currentScore'] ?? 0,
        highScore: json['highScore'] ?? 0,
        isPlaying: json['isPlaying'] ?? false,
        isGameOver: json['isGameOver'] ?? false,
      );
}
