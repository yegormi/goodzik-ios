import SwiftUI

@Observable
public final class TabBarVisibilityController {
    private(set) var isVisible = true
    private var states = [true]

    func push(_ isVisible: Bool) {
        self.states.append(isVisible)
        self.isVisible = isVisible
    }

    func pop() {
        guard self.states.count > 1 else { return }
        self.states.removeLast()
        self.isVisible = self.states.last ?? true
    }

    func reset() {
        self.states = [true]
        self.isVisible = true
    }
}

private struct TabBarVisibilityKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue = TabBarVisibilityController()
}

extension EnvironmentValues {
    var tabBarVisibilityController: TabBarVisibilityController {
        get { self[TabBarVisibilityKey.self] }
        set { self[TabBarVisibilityKey.self] = newValue }
    }
}

// MARK: - View Modifiers

struct TabBarVisibilityModifier: ViewModifier {
    let isVisible: Bool
    @Environment(\.tabBarVisibilityController) private var controller

    func body(content: Content) -> some View {
        content
            .onAppear { self.controller.push(self.isVisible) }
            .onDisappear { self.controller.pop() }
    }
}

public extension View {
    func tabBarVisibility(_ isVisible: Bool) -> some View {
        modifier(TabBarVisibilityModifier(isVisible: isVisible))
    }
}
