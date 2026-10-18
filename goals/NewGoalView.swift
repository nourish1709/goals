import SwiftUI
import SwiftData

struct NewGoalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var why = ""
    @State private var selectedColor: GoalColor = .blue
    @State private var subgoalTitles: [String] = [""]

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Goal") {
                    TextField("What do you want to achieve?", text: $title)
                        .textInputAutocapitalization(.sentences)

                    TextField(
                        "Why does this matter to you?",
                        text: $why,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                }

                Section("Color") {
                    Picker("Color", selection: $selectedColor) {
                        ForEach(GoalColor.allCases) { color in
                            Label(color.name, systemImage: "circle.fill")
                                .foregroundStyle(color.swiftUIColor)
                                .tag(color)
                        }
                    }
                    .pickerStyle(.inline)
                }

                Section("First steps") {
                    ForEach($subgoalTitles.indices, id: \.self) { index in
                        HStack {
                            TextField(
                                "Subgoal \(index + 1)",
                                text: $subgoalTitles[index]
                            )

                            Button {
                                subgoalTitles.remove(at: index)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(.plain)
                            .disabled(subgoalTitles.count <= 1)
                        }
                    }

                    Button {
                        subgoalTitles.append("")
                    } label: {
                        Label("Add subgoal", systemImage: "plus.circle")
                    }
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveGoal()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canSave)
                }
            }
        }
    }

    private func saveGoal() {
        let cleanTitle = title.trimmingCharacters(in: .whitespaces)
        let cleanWhy = why.trimmingCharacters(in: .whitespaces)

        let goal = Goal(
            title: cleanTitle,
            why: cleanWhy,
            colorHex: selectedColor.hexValue
        )

        let cleanSubgoalTitles = subgoalTitles
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        for subgoalTitle in cleanSubgoalTitles {
            goal.subgoals.append(Subgoal(title: subgoalTitle))
        }

        modelContext.insert(goal)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            // In a production app, show an alert or log this error.
            print("Failed to save goal: \(error)")
        }
    }
}
