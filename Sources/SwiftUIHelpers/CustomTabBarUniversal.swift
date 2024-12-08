import SwiftUI

// MARK: - Core Types

public enum TabBarVisibility: Equatable {
    case visible
    case hidden

    var isVisible: Bool {
        switch self {
        case .visible: true
        case .hidden: false
        }
    }
}

public protocol TabItem: Hashable {
    var title: String { get }
    var icon: Image { get }
}

// MARK: - Styling

public protocol TabBarColorStyle {
    associatedtype Background: ShapeStyle
    associatedtype Selected: ShapeStyle
    associatedtype Foreground: ShapeStyle
    associatedtype ItemShape: Shape

    var background: Background { get }
    var selected: Selected { get }
    var foreground: Foreground { get }
    var selectedForeground: Foreground { get }
    var itemShape: ItemShape { get }
}

public struct DefaultTabBarStyle: TabBarColorStyle {
    public var background: some ShapeStyle { Color(.secondarySystemBackground).shadow(.drop(radius: 10, y: 5)) }
    public var selected: Color { .accentColor }
    public var foreground: Color { .primary }
    public var selectedForeground: Color { .white }
    public var itemShape: RoundedRectangle { RoundedRectangle(cornerRadius: 50) }

    public init() {}
}

public struct TabBarStyle<ColorStyle: TabBarColorStyle> {
    public typealias Default = TabBarStyle<DefaultTabBarStyle>

    let colorStyle: ColorStyle
    let buttonSize: CGFloat
    let iconSize: CGFloat
    let spacing: CGFloat
    let itemSpacing: CGFloat
    let padding: EdgeInsets
    let containerPadding: CGFloat
    let bottomPadding: CGFloat
    let showLabels: Bool
    let labelFont: Font
    let selectionAnimation: Animation
    let visibilityAnimation: Animation

    private init(
        colorStyle: ColorStyle,
        buttonSize: CGFloat,
        iconSize: CGFloat,
        spacing: CGFloat,
        itemSpacing: CGFloat,
        padding: EdgeInsets,
        containerPadding: CGFloat,
        bottomPadding: CGFloat,
        showLabels: Bool,
        labelFont: Font,
        selectionAnimation: Animation,
        visibilityAnimation: Animation
    ) {
        self.colorStyle = colorStyle
        self.buttonSize = buttonSize
        self.iconSize = iconSize
        self.spacing = spacing
        self.itemSpacing = itemSpacing
        self.padding = padding
        self.containerPadding = containerPadding
        self.bottomPadding = bottomPadding
        self.showLabels = showLabels
        self.labelFont = labelFont
        self.selectionAnimation = selectionAnimation
        self.visibilityAnimation = visibilityAnimation
    }

    public static var `default`: Default {
        Default(
            colorStyle: DefaultTabBarStyle(),
            buttonSize: 50,
            iconSize: 20,
            spacing: 8,
            itemSpacing: 8,
            padding: EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5),
            containerPadding: 16,
            bottomPadding: 30,
            showLabels: false,
            labelFont: .system(size: 11),
            selectionAnimation: .spring(response: 0.3, dampingFraction: 0.7),
            visibilityAnimation: .spring(response: 0.3, dampingFraction: 0.8)
        )
    }
}

// MARK: - Tab Bar State Management

@Observable
public final class TabBarController {
    @MainActor private(set) var visibility: TabBarVisibility = .visible

    @MainActor private var states: [TabBarVisibility] = [.visible]

    public init() {}

    @MainActor
    func push(_ state: TabBarVisibility) {
        self.states.append(state)
        self.visibility = state
    }

    @MainActor
    func pop() {
        guard self.states.count > 1 else { return }
        self.states.removeLast()
        self.visibility = self.states.last ?? .visible
    }

    @MainActor
    func reset() {
        self.states = [.visible]
        self.visibility = .visible
    }
}

// MARK: - Tab Bar Components

struct TabBarButton<T: TabItem, Style: TabBarColorStyle>: View {
    let item: T
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    let style: TabBarStyle<Style>

    var body: some View {
        Button(action: self.action) {
            VStack(spacing: self.style.spacing) {
                ZStack {
                    if self.isSelected {
                        self.style.colorStyle.itemShape
                            .fill(self.style.colorStyle.selected)
                            .matchedGeometryEffect(id: "background", in: self.namespace)
                    }

                    VStack(spacing: 2) {
                        self.item.icon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: self.style.iconSize, height: self.style.iconSize)
                            .foregroundStyle(
                                self.isSelected ? self.style.colorStyle.selectedForeground : self.style.colorStyle
                                    .foreground
                            )
                        if self.style.showLabels {
                            Text(self.item.title)
                                .font(self.style.labelFont)
                                .foregroundStyle(
                                    self.isSelected ? self.style.colorStyle.selectedForeground : self.style.colorStyle
                                        .foreground
                                )
                        }
                    }
                }
                .frame(width: self.style.buttonSize, height: self.style.buttonSize)
            }
        }
        .buttonStyle(.plain)
    }
}

public struct CustomTabBar<T: TabItem, Style: TabBarColorStyle>: View {
    let items: [T]
    let selection: T
    let onSelect: (T) -> Void
    let style: TabBarStyle<Style>

    @Namespace private var namespace

    public var body: some View {
        HStack(spacing: self.style.itemSpacing) {
            ForEach(self.items, id: \.self) { item in
                TabBarButton(
                    item: item,
                    isSelected: item == self.selection,
                    namespace: self.namespace,
                    action: { self.onSelect(item) },
                    style: self.style
                )
            }
        }
        .padding(self.style.padding)
        .background {
            self.style.colorStyle.itemShape
                .fill(self.style.colorStyle.background)
        }
    }
}

public struct CustomTabContainerUniversal<T: TabItem, Style: TabBarColorStyle, Content: View>: View {
    let items: [T]
    @Binding var selection: T
    let content: () -> Content
    let style: TabBarStyle<Style>

    @State private var controller = TabBarController()

    public init(
        items: [T],
        selection: Binding<T>,
        style: TabBarStyle<Style>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.items = items
        self._selection = selection
        self.style = style
        self.content = content
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: self.$selection) {
                self.content()
                    .toolbar(.hidden, for: .tabBar)
            }
            .onChange(of: self.selection) {
                self.controller.reset()
            }

            CustomTabBar(
                items: self.items,
                selection: self.selection,
                onSelect: { tab in
                    withAnimation(self.style.selectionAnimation) {
                        self.selection = tab
                    }
                },
                style: self.style
            )
            .padding(.horizontal, self.style.containerPadding)
            .safeAreaPadding(.bottom, self.style.bottomPadding)
            .opacity(self.controller.visibility.isVisible ? 1 : 0)
            .offset(y: self.controller.visibility.isVisible ? 0 : 100)
        }
        .animation(self.style.visibilityAnimation, value: self.controller.visibility)
        .ignoresSafeArea(edges: .bottom)
        .environment(\.tabBarController, self.controller)
    }
}

// MARK: - Environment

private struct TabBarControllerKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue = TabBarController()
}

extension EnvironmentValues {
    var tabBarController: TabBarController {
        get { self[TabBarControllerKey.self] }
        set { self[TabBarControllerKey.self] = newValue }
    }
}

// MARK: - View Modifiers

struct TabBarVisibilityModifier: ViewModifier {
    let visibility: TabBarVisibility
    @Environment(\.tabBarController) private var controller

    func body(content: Content) -> some View {
        content
            .onAppear { self.controller.push(self.visibility) }
            .onDisappear { self.controller.pop() }
    }
}

// MARK: - View Extensions

public extension View {
    func tabBarVisibility(_ visibility: TabBarVisibility) -> some View {
        modifier(TabBarVisibilityModifier(visibility: visibility))
    }
}
