import SwiftUI
import SwiftData

struct RealityCheckSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var goal: Goal
    @State private var reflection = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("“\(goal.title)”")
                    .font(.title2.bold())

                Text("Do you still genuinely want to spend time on this, or was it an interest for a particular moment?")
                    .foregroundStyle(.secondary)

                TextEditor(text: $reflection)
                    .frame(minHeight: 120)
                    .scrollContentBackground(.hidden)
                    .padding(12)
                    .background(.quaternary, in: .rect(cornerRadius: 12))

                VStack(spacing: 12) {
                    Button {
                        goal.status = .active
                        saveAndDismiss()
                    } label: {
                        Label("This still matters to me", systemImage: "flame.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        goal.status = .paused
                        saveAndDismiss()
                    } label: {
                        Label("Pause for now", systemImage: "pause.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button(role: .destructive) {
                        goal.status = .released
                        saveAndDismiss()
                    } label: {
                        Label("This was not truly my wish", systemImage: "heart.slash")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .navigationTitle("Reality check")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveAndDismiss() {
        if !reflection.trimmingCharacters(in: .whitespaces).isEmpty {
            goal.why = reflection
        }

        try? modelContext.save()
        dismiss()
    }
}
