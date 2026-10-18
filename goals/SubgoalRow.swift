import SwiftUI

struct SubgoalRow: View {
    @Bindable var subgoal: Subgoal

    var body: some View {
        HStack {
            Button {
                subgoal.isCompleted.toggle()

                if subgoal.isCompleted {
                    subgoal.completedAt = Date()
                } else {
                    subgoal.completedAt = nil
                }
            } label: {
                Image(systemName: subgoal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(subgoal.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)

            TextField("Subgoal", text: $subgoal.title)
                .strikethrough(subgoal.isCompleted)
                .foregroundStyle(subgoal.isCompleted ? .secondary : .primary)
        }
    }
}
