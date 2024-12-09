import SwiftUI

private struct TabBarBadge: View {
    private let count: Int
    private let style: TabBarBadgeStyle

    init(count: Int, style: TabBarBadgeStyle) {
        self.count = count
        self.style = style
    }

    var body: some View {
        Text("\(self.count)")
            .font(self.style.font)
            .foregroundStyle(self.style.foregroundColor)
            .padding(self.style.padding)
            .background(
                Circle()
                    .fill(self.style.backgroundColor)
            )
            .contentShape(Circle())
            .offset(x: 10, y: -10)
    }
}

private struct TabBarButton<Item: TabBarItem, Theme: TabBarTheme>: View {
    private let item: Item
    private let isSelected: Bool
    private let namespace: Namespace.ID
    private let config: TabBarConfiguration<Theme>
    private let action: () -> Void

    init(
        item: Item,
        isSelected: Bool,
        namespace: Namespace.ID,
        config: TabBarConfiguration<Theme>,
        action: @escaping () -> Void
    ) {
        self.item = item
        self.isSelected = isSelected
        self.namespace = namespace
        self.config = config
        self.action = action
    }

    var body: some View {
        Button {
            HapticManager.shared.trigger(self.config.haptics)
            self.action()
        } label: {
            ZStack {
                if self.isSelected {
                    self.config.theme.activeItemShape
                        .fill(self.config.theme.activeItemBackgroundColor)
                        .frame(width: self.config.layout.itemSize.width, height: self.config.layout.itemSize.height)
                        .transition(.symbolEffect)
                        .matchedGeometryEffect(id: "background", in: self.namespace)
                }

                VStack(spacing: self.config.layout.labelSpacing) {
                    self.item.icon
                        .frame(width: self.config.layout.iconSize.width, height: self.config.layout.iconSize.height)
                        .overlay(alignment: .topTrailing) {
                            if let count = item.badgeCount, count > 0 {
                                TabBarBadge(count: count, style: self.config.theme.badgeStyle)
                            }
                        }
                        .foregroundStyle(
                            self.isSelected ? self.config.theme.activeItemColor : self.config.theme.inactiveItemColor
                        )

                    if self.config.showLabels {
                        Text(self.item.title)
                            .font(self.config.labelFont)
                            .foregroundStyle(
                                self.isSelected ? self.config.theme.activeItemColor : self.config.theme.inactiveItemColor
                            )
                    }
                }
                .frame(width: self.config.layout.itemSize.width, height: self.config.layout.itemSize.height)
                .contentShape(Rectangle()) // Just to make the whole area tappable
            }
        }
        .buttonStyle(.plain)
    }
}

private struct CustomTabBar<Item: TabBarItem, Theme: TabBarTheme>: View {
    private let items: [Item]
    @Binding private var selection: Item
    private let config: TabBarConfiguration<Theme>

    init(
        items: [Item],
        selection: Binding<Item>,
        config: TabBarConfiguration<Theme>
    ) {
        self._selection = selection
        self.items = items
        self.config = config
    }

    @Namespace private var namespace

    var body: some View {
        HStack(spacing: self.config.layout.itemSpacing) {
            ForEach(self.items) { item in
                TabBarButton(
                    item: item,
                    isSelected: item == self.selection,
                    namespace: self.namespace,
                    config: self.config
                ) {
                    withAnimation(self.config.animation.selection) {
                        self.selection = item
                    }
                }
            }
        }
        .padding(self.config.layout.contentPadding)
        .background {
            self.config.theme.containerShape
                .fill(self.config.theme.containerBackground)
        }
    }
}

public struct TabBarContainer<Item: TabBarItem, Theme: TabBarTheme, Content: View>: View {
    private let items: [Item]
    @Binding private var selection: Item
    private let config: TabBarConfiguration<Theme>
    @ViewBuilder private let content: () -> Content

    @State private var visibilityController = TabBarVisibilityController()

    public init(
        items: [Item],
        selection: Binding<Item>,
        config: TabBarConfiguration<Theme>,
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
                self.visibilityController.reset()
            }

            CustomTabBar(
                items: self.items,
                selection: self.$selection,
                config: self.config
            )
            .safeAreaPadding(self.config.layout.safeAreaPadding)
            .opacity(self.visibilityController.isVisible ? 1 : 0)
            .offset(y: self.visibilityController.isVisible ? 0 : 100)
            .animation(self.config.animation.visibility, value: self.visibilityController.isVisible)
        }
        .ignoresSafeArea(edges: .bottom)
        .environment(\.tabBarVisibilityController, self.visibilityController)
    }
}
