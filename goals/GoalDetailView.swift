import SwiftUI
import SwiftData

struct GoalDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var goal: Goal

    @State private var newSubgoalTitle = ""
    @State private var isTimerRunning = false
    @State private var currentSessionStart: Date?
    @State private var showRealityCheck = false
    @State private var showRemoveOptions = false

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(goal.title)
                        .font(.largeTitle.bold())

                    if !goal.why.isEmpty {
                        Text("Why: \(goal.why)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Label(goal.formattedTotalTime, systemImage: "clock")
                            .font(.headline)

                        Spacer()

                        Text("\(goal.subgoals.filter(\.isCompleted).count)/\(goal.subgoals.count) done")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 4)
                }
                .padding(.vertical, 8)
            }

            Section("Focus") {
                if isTimerRunning, let start = currentSessionStart {
                    TimelineView(.periodic(from: start, by: 1)) { context in
                        Label(
                            Duration.seconds(context.date.timeIntervalSince(start))
                                .formatted(.time(pattern: .hourMinuteSecond)),
                            systemImage: "timer"
                        )
                        .font(.title2.monospacedDigit())
                    }

                    Button(role: .destructive) {
                        stopSession()
                    } label: {
                        Label("Stop session", systemImage: "stop.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                } else {
                    Button {
                        startSession()
                    } label: {
                        Label("Start focus session", systemImage: "play.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }

            Section("Subgoals") {
                ForEach(goal.subgoals) { subgoal in
                    SubgoalRow(subgoal: subgoal)
                }
                .onDelete { offsets in
                    deleteSubgoals(at: offsets)
                }

                HStack {
                    TextField("Add a subgoal", text: $newSubgoalTitle)
                        .onSubmit(addSubgoal)

                    Button {
                        addSubgoal()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(newSubgoalTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }

            Section("Reflection") {
                Button {
                    showRealityCheck = true
                } label: {
                    Label("Is this still important to me?", systemImage: "heart.text.square")
                }

                Picker("Status", selection: $goal.status) {
                    ForEach(GoalStatus.allCases, id: \.self) { status in
                        Text(status.title).tag(status)
                    }
                }

                if goal.status != .active {
                    Button {
                        setStatusAndDismiss(.active)
                    } label: {
                        Label("Reactivate goal", systemImage: "arrow.counterclockwise")
                    }
                }
            }

            Section {
                Button(role: .destructive) {
                    showRemoveOptions = true
                } label: {
                    Label("Remove goal", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Goal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    GoalStatisticsView(goal: goal)
                } label: {
                    Image(systemName: "chart.bar")
                }
            }
        }
        .sheet(isPresented: $showRealityCheck) {
            RealityCheckSheet(goal: goal)
                .presentationDetents([.medium])
        }
        .confirmationDialog("Remove this goal?", isPresented: $showRemoveOptions) {
            Button("Archive for later review") {
                setStatusAndDismiss(.archived)
            }

            Button("Delete forever", role: .destructive) {
                deleteGoal()
            }
        } message: {
            Text("Archived goals stay in the Archived list. You can activate them again.")
        }
    }

    private func startSession() {
        currentSessionStart = Date()
        isTimerRunning = true
    }

    private func stopSession() {
        guard let start = currentSessionStart else { return }

        let session = FocusSession(
            startedAt: start,
            endedAt: Date()
        )

        goal.sessions.append(session)
        isTimerRunning = false
        currentSessionStart = nil

        try? modelContext.save()
    }

    private func addSubgoal() {
        let title = newSubgoalTitle.trimmingCharacters(in: .whitespaces)
        guard !title.isEmpty else { return }

        goal.subgoals.append(Subgoal(title: title))
        newSubgoalTitle = ""

        try? modelContext.save()
    }

    private func deleteSubgoals(at offsets: IndexSet) {
        goal.subgoals.remove(atOffsets: offsets)
        try? modelContext.save()
    }

    private func setStatusAndDismiss(_ status: GoalStatus) {
        goal.status = status
        try? modelContext.save()
        dismiss()
    }

    private func deleteGoal() {
        modelContext.delete(goal)
        dismiss()
    }
}
