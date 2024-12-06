import ComposableArchitecture
import Observation
import SwiftUI

// MARK: - Tab Bar Hide State

public enum TabBarHideState: Equatable, Sendable {
    case visible
    case temporaryHidden
    case permanentlyHidden
}

// MARK: - Models

public struct TabBarItem: Identifiable {
    public let id = UUID()
    let tab: AnyHashable
    let title: String
    let image: Image

    public init(tab: AnyHashable, title: String, resource: ImageResource) {
        self.tab = tab
        self.title = title
        self.image = Image(resource)
    }
}

// MARK: - Tab Bar State Manager

@Observable
final class TabBarStateManager {
    private(set) var hideState: TabBarHideState = .visible
    private var stateStack: [TabBarHideState] = [.visible]

    func pushState(_ state: TabBarHideState) {
        self.stateStack.append(state)
        self.hideState = state
    }

    func popState() {
        guard self.stateStack.count > 1 else { return }
        self.stateStack.removeLast()
        self.hideState = self.stateStack.last ?? .visible
    }

    func reset() {
        self.stateStack = [.visible]
        self.hideState = .visible
    }
}

// MARK: - Custom Tab Bar View

public struct CustomTabBar<Tab: Hashable>: View {
    let items: [TabBarItem]
    let selectedTab: Tab
    let onSelect: (Tab) -> Void
    @Namespace private var namespace

    public init(
        items: [TabBarItem],
        selectedTab: Tab,
        onSelect: @escaping (Tab) -> Void
    ) {
        self.items = items
        self.selectedTab = selectedTab
        self.onSelect = onSelect
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(self.items) { item in
                TabBarButton(
                    item: item,
                    isSelected: self.selectedTab as AnyHashable == item.tab,
                    namespace: self.namespace
                ) {
                    self.onSelect(item.tab as! Tab)
                }
            }
        }
        .padding(5)
        .background {
            RoundedRectangle(cornerRadius: 50)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: Color.black.opacity(0.3), radius: 10, y: 5)
        }
    }
}

// MARK: - Tab Bar Button

private struct TabBarButton: View {
    let item: TabBarItem
    let isSelected: Bool
    let namespace: Namespace.ID
    let onTap: () -> Void

    var body: some View {
        Button(action: self.onTap) {
            ZStack {
                if self.isSelected {
                    Circle()
                        .fill(.black)
                        .matchedGeometryEffect(id: "background_circle", in: self.namespace)
                        .frame(width: 50, height: 50)
                }

                self.item.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(self.isSelected ? .white : .black)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: self.isSelected)
                    .padding(30)
            }
            .frame(width: 50, height: 50)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Custom Tab View Container

public struct CustomTabViewContainerExtra<Tab: Hashable, Content: View>: View {
    let tabs: [TabBarItem]
    @Binding var selectedTab: Tab
    let content: () -> Content

    @State private var stateManager = TabBarStateManager()

    public init(
        tabs: [TabBarItem],
        selectedTab: Binding<Tab>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.tabs = tabs
        self._selectedTab = selectedTab
        self.content = content
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: self.$selectedTab) {
                self.content()
                    .toolbar(.hidden, for: .tabBar)
            }
            .onChange(of: self.selectedTab) { _, _ in
                self.stateManager.reset()
            }

            CustomTabBar(items: self.tabs, selectedTab: self.selectedTab) { newTab in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    self.selectedTab = newTab
                }
            }
            .padding(.horizontal)
            .safeAreaPadding(.bottom, 30)
            .opacity(self.stateManager.hideState == .visible ? 1 : 0)
            .offset(y: self.stateManager.hideState == .visible ? 0 : 100)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: self.stateManager.hideState)
        .ignoresSafeArea(edges: .bottom)
        .environment(\.tabBarStateManager, self.stateManager)
    }
}

// MARK: - Environment Keys

private struct TabBarStateManagerKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue = TabBarStateManager()
}

extension EnvironmentValues {
    var tabBarStateManager: TabBarStateManager {
        get { self[TabBarStateManagerKey.self] }
        set { self[TabBarStateManagerKey.self] = newValue }
    }
}

// MARK: - View Modifiers

struct TabBarVisibilityModifier: ViewModifier {
    let hideState: TabBarHideState
    @Environment(\.tabBarStateManager) private var stateManager

    func body(content: Content) -> some View {
        content
            .onAppear {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    self.stateManager.pushState(self.hideState)
                }
            }
            .onWillDisappear {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    self.stateManager.popState()
                }
            }
    }
}

// MARK: - View Extensions

public extension View {
    /// Sets the visibility state of the custom tab bar.
    /// - Parameter hideState: The desired hide state for the tab bar.
    /// - Returns: A modified view with the specified tab bar visibility.
    func tabBarVisibility(_ hideState: TabBarHideState) -> some View {
        modifier(TabBarVisibilityModifier(hideState: hideState))
    }
}
