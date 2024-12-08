import UIKit

@MainActor
public protocol HapticFeedback {
    func trigger()
    func prepare()
}

public enum HapticFeedbackType: Equatable {
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case selection
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case none

    @MainActor var generator: HapticFeedback {
        switch self {
        case let .impact(style):
            ImpactHapticFeedback(style: style)
        case .selection:
            SelectionHapticFeedback()
        case let .notification(type):
            NotificationHapticFeedback(type: type)
        case .none:
            NoHapticFeedback()
        }
    }
}

@MainActor
private final class ImpactHapticFeedback: HapticFeedback {
    private let generator: UIImpactFeedbackGenerator

    init(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        self.generator = UIImpactFeedbackGenerator(style: style)
    }

    func trigger() {
        self.generator.impactOccurred()
    }

    func prepare() {
        self.generator.prepare()
    }
}

private final class SelectionHapticFeedback: HapticFeedback {
    private let generator: UISelectionFeedbackGenerator

    init() {
        self.generator = UISelectionFeedbackGenerator()
    }

    func trigger() {
        self.generator.selectionChanged()
    }

    func prepare() {
        self.generator.prepare()
    }
}

private final class NotificationHapticFeedback: HapticFeedback {
    private let generator: UINotificationFeedbackGenerator
    private let type: UINotificationFeedbackGenerator.FeedbackType

    init(type: UINotificationFeedbackGenerator.FeedbackType) {
        self.generator = UINotificationFeedbackGenerator()
        self.type = type
    }

    func trigger() {
        self.generator.notificationOccurred(self.type)
    }

    func prepare() {
        self.generator.prepare()
    }
}

private final class NoHapticFeedback: HapticFeedback {
    func trigger() {}
    func prepare() {}
}

@Observable
final class HapticManager {
    @MainActor static let shared = HapticManager()
    private var currentFeedback: HapticFeedback?

    private init() {}

    @MainActor
    func trigger(_ type: HapticFeedbackType) {
        self.currentFeedback = type.generator
        self.currentFeedback?.prepare()
        self.currentFeedback?.trigger()
    }
}
