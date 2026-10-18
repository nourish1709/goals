import SwiftData
import Foundation

@Model
final class Goal {
    var title: String
    var why: String
    var createdAt: Date
    var status: GoalStatus
    var colorHex: String

    @Relationship(deleteRule: .cascade, inverse: \Subgoal.goal)
    var subgoals: [Subgoal] = []

    @Relationship(deleteRule: .cascade, inverse: \FocusSession.goal)
    var sessions: [FocusSession] = []

    init(
        title: String,
        why: String = "",
        colorHex: String = "#4F8EF7",
        status: GoalStatus = .active
    ) {
        self.title = title
        self.why = why
        self.createdAt = Date()
        self.status = status
        self.colorHex = colorHex
    }

    var totalSeconds: TimeInterval {
        sessions.reduce(0) { $0 + $1.duration }
    }

    var formattedTotalTime: String {
        Duration.seconds(totalSeconds).formatted(.time(pattern: .hourMinuteSecond))
    }
}

enum GoalStatus: String, Codable {
    case active
    case paused
    case released
}

@Model
final class Subgoal {
    var title: String
    var isCompleted: Bool
    var completedAt: Date?
    var createdAt: Date
    var goal: Goal?

    init(title: String) {
        self.title = title
        self.isCompleted = false
        self.createdAt = Date()
    }
}

@Model
final class FocusSession {
    var startedAt: Date
    var endedAt: Date
    var note: String
    var goal: Goal?

    init(startedAt: Date, endedAt: Date, note: String = "") {
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.note = note
    }

    var duration: TimeInterval {
        endedAt.timeIntervalSince(startedAt)
    }
}
