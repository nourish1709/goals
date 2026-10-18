import SwiftUI

enum GoalColor: String, CaseIterable, Identifiable {
    case blue
    case green
    case orange
    case purple
    case red
    case teal

    var id: String { rawValue }

    var name: String {
        switch self {
        case .blue: "Blue"
        case .green: "Green"
        case .orange: "Orange"
        case .purple: "Purple"
        case .red: "Red"
        case .teal: "Teal"
        }
    }

    var swiftUIColor: Color {
        switch self {
        case .blue: .blue
        case .green: .green
        case .orange: .orange
        case .purple: .purple
        case .red: .red
        case .teal: .teal
        }
    }

    var hexValue: String {
        switch self {
        case .blue: "#4F8EF7"
        case .green: "#34C759"
        case .orange: "#FF9500"
        case .purple: "#AF52DE"
        case .red: "#FF3B30"
        case .teal: "#30B0C7"
        }
    }
}
