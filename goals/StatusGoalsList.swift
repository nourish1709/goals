import SwiftUI
import SwiftData

struct StatusGoalsList: View {
    @Query private var goals: [Goal]

    private let status: GoalStatus

    init(status: GoalStatus) {
        self.status = status

        // Predicates can't reference enum cases or properties directly, so capture the value locally.
        let selectedStatus = status
        _goals = Query(
            filter: #Predicate<Goal> { $0.status == selectedStatus },
            sort: \Goal.createdAt,
            order: .reverse
        )
    }

    var body: some View {
        List {
            ForEach(goals) { goal in
                NavigationLink(value: goal) {
                    GoalRow(goal: goal)
                }
            }
        }
        .overlay {
            if goals.isEmpty {
                ContentUnavailableView(
                    "No \(status.title.lowercased()) goals",
                    systemImage: "tray"
                )
            }
        }
    }
}
