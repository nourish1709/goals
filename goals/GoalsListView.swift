import SwiftUI
import SwiftData

// Predicates can't reference enum cases directly, so capture the value as a constant.
private let activeStatus = GoalStatus.active

struct GoalsListView: View {
    @Query(
        filter: #Predicate<Goal> { $0.status == activeStatus },
        sort: \Goal.createdAt,
        order: .reverse
    )
    private var activeGoals: [Goal]

    @State private var isShowingNewGoal = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(activeGoals) { goal in
                    NavigationLink(value: goal) {
                        GoalRow(goal: goal)
                    }
                }
            }
            .navigationTitle("My Goals")
            .navigationDestination(for: Goal.self) { goal in
                GoalDetailView(goal: goal)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingNewGoal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingNewGoal) {
                NewGoalView()
            }
        }
    }
}
