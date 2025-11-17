# Doodle Jump Game - Architecture Plan

## Overview
A Doodle Jump-style tapping game built with Flame engine, featuring smooth physics, platform generation, and modern UI with elegant colors and fonts.
Testing Branch
## Technical Stack
- **Game Engine**: Flame (for game loop, collision detection, physics)
- **State Management**: Provider (for game state, high scores)
- **Navigation**: go_router
- **Local Storage**: shared_preferences (for high scores)
- **Design**: Custom sleek UI with vibrant colors, avoiding Material Design

## Core Features

### 1. Game Mechanics
- Player character that bounces upward when tapping
- Auto-generated platforms at increasing heights
- Gravity and physics simulation
- Collision detection with platforms
- Score tracking based on height climbed
- Game over when player falls off screen

### 2. Platform Types
- Normal platforms (green) - standard bounce
- Moving platforms (blue) - horizontal movement
- Fragile platforms (brown) - break after one bounce

### 3. UI Components
- Main menu screen with play button and high score
- Game screen with live score display
- Game over overlay with restart option
- Modern, sleek design with gradient backgrounds

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── theme.dart                # Theme with vibrant game colors
├── screens/
│   ├── menu_screen.dart      # Main menu
│   └── game_screen.dart      # Game container
├── game/
│   ├── doodle_game.dart      # Main Flame game class
│   ├── components/
│   │   ├── player.dart       # Player character component
│   │   ├── platform.dart     # Platform component
│   │   └── background.dart   # Animated background
│   └── managers/
│       └── platform_manager.dart  # Platform generation logic
├── models/
│   └── game_state.dart       # Game state model
└── services/
    └── score_service.dart    # High score persistence
```

## Data Models

### GameState
```dart
class GameState {
  int currentScore;
  int highScore;
  bool isPlaying;
  bool isGameOver;
}
```

## Implementation Steps

1. **Setup & Dependencies**
   - Add flame, shared_preferences packages
   - Update theme.dart with vibrant game colors (purple, cyan, yellow gradient)
   - Use Poppins font for modern, playful look

2. **Data Layer**
   - Create GameState model with game status
   - Create ScoreService for high score persistence

3. **Game Engine (Flame)**
   - Implement DoodleGame class extending FlameGame
   - Create Player component with jump physics
   - Create Platform component with different types
   - Implement PlatformManager for procedural generation
   - Add collision detection between player and platforms
   - Create animated gradient background

4. **UI Screens**
   - Build MenuScreen with sleek design, play button, high score display
   - Build GameScreen with Flame GameWidget
   - Add score overlay during gameplay
   - Create game over overlay with restart

5. **Game Logic**
   - Implement tap-to-jump mechanism
   - Add gravity and velocity physics
   - Track score based on height climbed
   - Handle game over condition
   - Save/load high scores

6. **Polish**
   - Add smooth animations
   - Implement particle effects
   - Add sound feedback (optional)
   - Ensure responsive design for different screen sizes

7. **Testing & Debugging**
   - Run compile_project to check for errors
   - Test game mechanics
   - Verify high score persistence
   - Check performance

## Design Specifications

### Color Palette (Vibrant & Energetic)
- **Primary**: Deep Purple (#6B4CE6) - main UI elements
- **Secondary**: Cyan (#00D9FF) - accents, highlights
- **Accent**: Yellow (#FFD93D) - score, important buttons
- **Background**: Gradient from deep blue (#1A1A2E) to purple (#6B4CE6)
- **Text**: White (#FFFFFF) with shadow for readability

### Typography
- **Display**: Poppins Bold - menu titles
- **Score**: Poppins SemiBold - in-game score
- **Body**: Poppins Regular - descriptions

### Spacing
- Generous padding (24-32px) around UI elements
- Large tap targets (56px minimum)
- Smooth rounded corners (16-24px radius)

## Key Technical Decisions
- Use Flame for game loop and physics (60 FPS target)
- Provider for reactive state updates to UI
- Local storage only (no backend required)
- Platform generation algorithm: spawn new platforms as player climbs
- Collision detection using Flame's built-in system
