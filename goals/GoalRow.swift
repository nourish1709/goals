import SwiftUI
import SwiftData

struct GoalRow: View {
    let goal: Goal

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(goal.title)
                .font(.headline)

            Text(goal.formattedTotalTime)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
