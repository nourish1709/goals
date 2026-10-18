import SwiftUI
import SwiftData

struct GoalStatisticsView: View {
    let goal: Goal

    var body: some View {
        List {
            Section("Summary") {
                LabeledContent("Total time", value: goal.formattedTotalTime)
                LabeledContent("Sessions", value: "\(goal.sessions.count)")
                LabeledContent(
                    "Completed subgoals",
                    value: "\(goal.subgoals.filter(\.isCompleted).count)/\(goal.subgoals.count)"
                )
            }

            Section("Recent sessions") {
                ForEach(
                    goal.sessions
                        .sorted { $0.startedAt > $1.startedAt }
                        .prefix(10)
                ) { session in
                    VStack(alignment: .leading) {
                        Text(session.startedAt, format: .dateTime.day().month().hour().minute())
                        Text(Duration.seconds(session.duration)
                            .formatted(.time(pattern: .hourMinuteSecond)))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Statistics")
    }
}
