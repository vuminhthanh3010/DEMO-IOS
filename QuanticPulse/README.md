# QuanticPulse (UIKit)

A unique rhythm-puzzle game built with UIKit, fully programmatic UI, no images. Your goal: pick the correct target instruction, then tap the right icon exactly on its target pulse.

## Why it is unique
- Pulse-driven interaction: icons flash on a fixed beat (pulse). You must tap an icon precisely at its target pulse.
- Double-check challenge: first choose the correct target instruction (multiple-choice), then time your tap.
- Dynamic fakes: misleading pulses appear on non-target beats to trick your reflex.

## Screens
- SplashViewController: Animated title, auto-push to Home after 2s.
- HomeViewController: Player name, tip of the day, buttons: Play, Tutorial, Leaderboard, Settings.
- LevelsViewController: Stylish collection of levels, lock/unlock progression.
- GameViewController: Core gameplay. Hints, 4 answer buttons + Submit, pulsating icons row, pause/skip, circular timer, score, streak toasts, animations and sounds.
- GameOverViewController: Card with score, level, replay/home/leaderboard. Saves results, unlocks next level on pass.
- LeaderboardViewController: Sorted entries with date/time and rank title (Rookie, Pro, Super).
- SettingsViewController: Dark Mode toggle (persisted), Share, Rate, version label, and a placeholder Experimental Challenge Mode.
- TutorialViewController: Swipeable onboarding pages.

## Data & Logic
- Levels and questions are read from `Resources/questions.json` (20 questions across 4 levels).
- Questions and options are shuffled each playthrough; option positions change every time.
- Console logs reveal the correct answer each time a question is shown (for QA/testing).
- Score system: +10 base with streak bonuses; penalties for wrong/skip; toast on streaks.
- Time is visualized via a circular progress ring.
- Pause and Skip are supported; Skip reduces score.
- Unlocks: beating a level unlocks the next level.

## Theming & UI
- 100% code-based UI (no Storyboards/XIBs, no images).
- Per-screen soft gradient backgrounds applied in `viewWillAppear` via a shared helper.
- Global Dark Mode toggle with persistence (UserDefaults) via `ThemeManager`.
- Modern, minimal UI with subtle animations and haptics.

## Sharing & Rating
- Share: `UIActivityViewController` with an app link placeholder.
- Rate: `SKStoreReviewController` request.

## Apple Review Compliance
- No private APIs. No deceptive behavior. No user tracking, no ads, no subscriptions.
- Content is safe for all ages, no UGC.
- Share and Rate use standard system components.
- Data stored locally via `UserDefaults` only.

## Home Extras
- Player name editing.
- Tip of the day.
- Experimental button (non-functional) listed in Settings for future modes, described here for transparency.

## Build & Run
- Create an iOS App project in Xcode named "QuanticPulse" (UIKit, Swift). Remove Storyboards, set deployment target iOS 15+.
- Add the files from this repo into the project. Ensure `Resources/questions.json` is added to the app target.
- Set `AppDelegate` as @main, keep `SceneDelegate` enabled.
- Run on a device or simulator.

## File Structure
- AppDelegate.swift, SceneDelegate.swift
- Controllers: Splash, Home, Levels, Game, GameOver, Leaderboard, Settings, Tutorial
- Managers: ThemeManager, StorageManager, SoundManager, Haptic, SettingsManager
- Models: Level, PulseQuestion, LeaderboardEntry
- Views: TimerProgressView (circular), PulseIconView (tappable icon), Toast
- Helpers: GradientBackground
- Resources: questions.json

## FAQ
- Why both multiple-choice and timing? It adds a unique two-step verification: choose correctly AND tap on-time.
- Where is the data stored? Locally in `UserDefaults` only.

## Credits
Built with love in Swift + UIKit.