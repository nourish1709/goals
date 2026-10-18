import SwiftUI
import SwiftData

@main
struct DreamTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            GoalsListView()
        }
        .modelContainer(for: [
            Goal.self,
            Subgoal.self,
            FocusSession.self
        ])
    }
}
