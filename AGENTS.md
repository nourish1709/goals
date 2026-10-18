# AGENTS.md

## Writing style

Use ASD-STE100 (Simplified Technical English) for all prose you write. This includes documentation, answers to the user, commit messages, and pull request descriptions.

- Write short sentences. Use a maximum of 20 words in an instruction and 25 words in a description.
- Use the active voice. Use the simple present tense for facts and the imperative for instructions.
- Use one word for one meaning. Do not use a different word for the same thing.
- Use the same noun every time. Do not use a synonym to avoid repetition.
- Put one instruction in each sentence.

Do not use ASD-STE100 for code. This includes identifiers, string literals, and comments in the code. Write them in normal English, as the existing code does.

## Project

DreamTracker (target `goals`): iOS app for tracking personal goals ("dreams"). User creates goals with a "why", logs timed focus sessions, breaks goals into subgoals, and periodically runs a "reality check" to decide whether a goal still matters (keep / pause / release).

- SwiftUI + SwiftData, no third-party deps, no tests yet.
- Swift 5 language mode, iOS deployment target 27.0, Xcode project `goals.xcodeproj` (no SPM/workspace).
- Bundle ID `com.yevheniisavonenkopersonalteam.goals`.
- Build: `xcodebuild -project goals.xcodeproj -scheme goals -destination 'generic/platform=iOS Simulator' build`

## Layout

All source in `goals/`, flat, one type per file.

| File | Role |
|------|------|
| `DreamTrackerApp.swift` | `@main`. Registers `modelContainer` for `Goal`, `Subgoal`, `FocusSession`. Root = `GoalsListView`. |
| `Goal.swift` | SwiftData models `Goal`, `Subgoal`, `FocusSession` + `GoalStatus` enum (`active`/`paused`/`released`). |
| `GoalColor.swift` | Color palette enum (name, `Color`, hex). Goal stores `colorHex` string, not enum. |
| `GoalsListView.swift` | Root list. `@Query` active goals, newest first. `NavigationStack` → `GoalDetailView`. "+" opens `NewGoalView`. |
| `NewGoalView.swift` | Sheet to create `Goal` (title, why, color). |
| `GoalDetailView.swift` | Focus timer, subgoals, reflection/status picker, delete, link to stats. |
| `GoalStatisticsView.swift` | Totals + 10 most recent sessions. |
| `RealityCheckSheet.swift` | Reflection sheet; sets goal status, optionally overwrites `why`. |
| `GoalRow.swift`, `SubgoalRow.swift` | List row views. |

`swift-for-java-developers.html` = personal Swift learning reference, not part of app.

## Data model

- `Goal` 1—* `Subgoal`, 1—* `FocusSession`; both relationships `.cascade` delete with inverse set.
- `Goal.totalSeconds` / `formattedTotalTime` derived from sessions; nothing stored.
- Only `active` goals show in list. Paused/released goals currently have no UI to view them.

## Conventions / gotchas

- Mutations go through `modelContext`; callers use `try? modelContext.save()` after changes.
- `#Predicate` can't reference enum cases directly → file-level constant (`activeStatus` in `GoalsListView.swift`). Follow that pattern for new status filters.
- Detail/sheet views take `@Bindable var goal: Goal`; read-only views take `let goal: Goal`.
- Focus timer state (`isTimerRunning`, `currentSessionStart`) is local `@State` in `GoalDetailView`: a session is lost if the view goes away mid-run. A `FocusSession` is only created on stop.
- Adding/renaming/retyping a model property is a SwiftData schema change; no migration plan exists yet.
- `Goal.colorHex` is stored but not yet used for rendering in rows/detail.
