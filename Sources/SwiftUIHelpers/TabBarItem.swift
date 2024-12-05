import SwiftUI
import SwiftUIHelpers

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
            ForEach(items) { item in
                TabBarButton(
                    item: item,
                    isSelected: selectedTab as AnyHashable == item.tab,
                    namespace: namespace,
                    onTap: { onSelect(item.tab as! Tab) }
                )
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
        Button(action: onTap) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(.black)
                        .matchedGeometryEffect(id: "background_circle", in: namespace)
                        .frame(width: 50, height: 50)
                }
                
                item.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(isSelected ? .white : .black)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            }
            .frame(width: 50, height: 50)
        }
        .buttonStyle(.plain)
    }
}

public extension EnvironmentValues {
    @Entry var tabBarState: TabBarState = .init(isHidden: false)
}

public extension View {
    func hideTabBar(_ hidden: Bool = true) -> some View {
        environment(\.tabBarState.isHidden, hidden)
    }
}

@Observable
public final class TabBarState {
    public var isHidden: Bool
    
    public init(isHidden: Bool) {
        self.isHidden = isHidden
    }
}

public struct CustomTabViewContainer<Tab: Hashable, Content: View>: View {
    let tabs: [TabBarItem]
    @Binding var selectedTab: Tab
    let content: () -> Content
    @Environment(\.tabBarState) private var tabBarState
    
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
            TabView(selection: $selectedTab) {
                self.content()
                    .toolbar(.hidden, for: .tabBar)
            }
            
            CustomTabBar(items: tabs, selectedTab: selectedTab) { newTab in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = newTab
                }
            }
            .padding(.horizontal)
            .safeAreaPadding(.bottom, 30)
            .opacity(tabBarState.isHidden ? 0 : 1)
            .animation(.spring(response: 0.3), value: tabBarState.isHidden)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
