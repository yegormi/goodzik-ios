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
    associatedtype ContainerBackground: ShapeStyle
    associatedtype SelectedItemBackground: ShapeStyle
    associatedtype SelectedItem: Shape
    associatedtype ItemForeground: ShapeStyle
    associatedtype Container: Shape

    // Container properties
    var containerBackgroundColor: ContainerBackground { get }
    var containerShape: Container { get }

    // Selected item properties
    var selectedItemBackgroundColor: SelectedItemBackground { get }
    var selectedItemForegroundColor: ItemForeground { get }
    var selectedItemShape: SelectedItem { get }

    // Unselected item properties
    var unselectedItemForegroundColor: ItemForeground { get }
}

public struct DefaultTabBarStyle: TabBarColorStyle {
    // Container properties
    public var containerBackgroundColor: some ShapeStyle {
        Color(.secondarySystemBackground).shadow(.drop(radius: 10, y: 5))
    }

    public var containerShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 50)
    }

    // Selected item properties
    public var selectedItemBackgroundColor: Color { .accentColor }
    public var selectedItemForegroundColor: Color { .white }
    public var selectedItemShape: Circle { Circle() }

    // Unselected item properties
    public var unselectedItemForegroundColor: Color { .primary }

    public init() {}
}

public struct TabBarConfig<ColorStyle: TabBarColorStyle> {
    public typealias Default = TabBarConfig<DefaultTabBarStyle>

    let style: ColorStyle
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

    var iconPadding: CGFloat {
        (self.buttonSize - self.iconSize) / 2
    }

    private init(
        style: ColorStyle,
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
        self.style = style
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
            style: DefaultTabBarStyle(),
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
    let config: TabBarConfig<Style>

    var body: some View {
        Button(action: self.action) {
            VStack(spacing: self.config.spacing) {
                ZStack {
                    if self.isSelected {
                        self.config.style.selectedItemShape
                            .fill(self.config.style.selectedItemBackgroundColor)
                            .frame(maxWidth: self.config.buttonSize, maxHeight: self.config.buttonSize)
                            .matchedGeometryEffect(id: "background", in: self.namespace)
                    }

                    VStack(spacing: 2) {
                        self.item.icon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: self.config.iconSize, maxHeight: self.config.iconSize)
                            .padding(self.config.iconPadding)
                            .contentShape(Rectangle())
                            .foregroundStyle(
                                self.isSelected ? self.config.style.selectedItemForegroundColor : self.config.style
                                    .unselectedItemForegroundColor
                            )
                        if self.config.showLabels {
                            Text(self.item.title)
                                .font(self.config.labelFont)
                                .foregroundStyle(
                                    self.isSelected ? self.config.style.selectedItemForegroundColor : self.config.style
                                        .unselectedItemForegroundColor
                                )
                        }
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

public struct CustomTabBar<T: TabItem, Style: TabBarColorStyle>: View {
    let items: [T]
    let selection: T
    let onSelect: (T) -> Void
    let config: TabBarConfig<Style>

    @Namespace private var namespace

    public var body: some View {
        HStack(spacing: self.config.itemSpacing) {
            ForEach(self.items, id: \.self) { item in
                TabBarButton(
                    item: item,
                    isSelected: item == self.selection,
                    namespace: self.namespace,
                    action: { self.onSelect(item) },
                    config: self.config
                )
            }
        }
        .padding(self.config.padding)
        .background {
            self.config.style.containerShape
                .fill(self.config.style.containerBackgroundColor)
        }
    }
}

public struct CustomTabContainerUniversal<T: TabItem, Style: TabBarColorStyle, Content: View>: View {
    let items: [T]
    @Binding var selection: T
    let content: () -> Content
    let config: TabBarConfig<Style>

    @State private var controller = TabBarController()

    public init(
        items: [T],
        selection: Binding<T>,
        config: TabBarConfig<Style>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.items = items
        self._selection = selection
        self.config = config
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
                    withAnimation(self.config.selectionAnimation) {
                        self.selection = tab
                    }
                },
                config: self.config
            )
            .padding(.horizontal, self.config.containerPadding)
            .safeAreaPadding(.bottom, self.config.bottomPadding)
            .opacity(self.controller.visibility.isVisible ? 1 : 0)
            .offset(y: self.controller.visibility.isVisible ? 0 : 100)
        }
        .animation(self.config.visibilityAnimation, value: self.controller.visibility)
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
