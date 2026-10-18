import SwiftUI
import SwiftData

struct GoalsListView: View {
    @State private var selectedStatus = GoalStatus.active
    @State private var isShowingNewGoal = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Status", selection: $selectedStatus) {
                    ForEach(GoalStatus.allCases, id: \.self) { status in
                        Text(status.title).tag(status)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 8)

                StatusGoalsList(status: selectedStatus)
                    .id(selectedStatus)
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
