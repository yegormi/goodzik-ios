// import ComposableArchitecture
// import SwiftUI
//
//// MARK: - Models
//
// public struct TabBarItem: Identifiable {
//    public let id = UUID()
//    let tab: AnyHashable
//    let title: String
//    let image: Image
//
//    public init(tab: AnyHashable, title: String, resource: ImageResource) {
//        self.tab = tab
//        self.title = title
//        self.image = Image(resource)
//    }
// }
//
//// MARK: - Custom Tab Bar View
//
// public struct CustomTabBar<Tab: Hashable>: View {
//    let items: [TabBarItem]
//    let selectedTab: Tab
//    let onSelect: (Tab) -> Void
//
//    @Namespace private var namespace
//
//    public init(
//        items: [TabBarItem],
//        selectedTab: Tab,
//        onSelect: @escaping (Tab) -> Void
//    ) {
//        self.items = items
//        self.selectedTab = selectedTab
//        self.onSelect = onSelect
//    }
//
//    public var body: some View {
//        HStack(spacing: 0) {
//            ForEach(self.items) { item in
//                TabBarButton(
//                    item: item,
//                    isSelected: self.selectedTab as AnyHashable == item.tab,
//                    namespace: self.namespace
//                ) {
//                    self.onSelect(item.tab as! Tab)
//                }
//            }
//        }
//        .padding(5)
//        .background {
//            RoundedRectangle(cornerRadius: 50)
//                .fill(Color(uiColor: .systemBackground))
//                .shadow(color: Color.black.opacity(0.3), radius: 10, y: 5)
//        }
//    }
// }
//
//// MARK: - Tab Bar Button
//
// private struct TabBarButton: View {
//    let item: TabBarItem
//    let isSelected: Bool
//    let namespace: Namespace.ID
//    let onTap: () -> Void
//
//    var body: some View {
//        Button(action: self.onTap) {
//            ZStack {
//                if self.isSelected {
//                    Circle()
//                        .fill(.black)
//                        .matchedGeometryEffect(id: "background_circle", in: self.namespace)
//                        .frame(width: 50, height: 50)
//                }
//
//                self.item.image
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 20, height: 20)
//                    .foregroundColor(self.isSelected ? .white : .black)
//                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: self.isSelected)
//                    .padding(30)
//            }
//            .frame(width: 50, height: 50)
//        }
//        .buttonStyle(.plain)
//    }
// }
//
// public struct CustomTabViewContainer<Tab: Hashable, Content: View>: View {
//    let tabs: [TabBarItem]
//    @Binding var selectedTab: Tab
//    let content: () -> Content
//
//    @Shared(.isTabBarHidden) var isHidden = false
//
//    public init(
//        tabs: [TabBarItem],
//        selectedTab: Binding<Tab>,
//        @ViewBuilder content: @escaping () -> Content
//    ) {
//        self.tabs = tabs
//        self._selectedTab = selectedTab
//        self.content = content
//    }
//
//    public var body: some View {
//        ZStack(alignment: .bottom) {
//            TabView(selection: self.$selectedTab) {
//                self.content()
//                    .toolbar(.hidden, for: .tabBar)
//            }
//
//            CustomTabBar(items: self.tabs, selectedTab: self.selectedTab) { newTab in
//                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                    self.selectedTab = newTab
//                }
//            }
//            .padding(.horizontal)
//            .safeAreaPadding(.bottom, 30)
//            .opacity(self.isHidden ? 0 : 1)
//            .offset(y: self.isHidden ? 100 : 0)
//        }
//        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: self.isHidden)
//        .ignoresSafeArea(edges: .bottom)
//    }
// }
//
// public extension SharedReaderKey where Self == InMemoryKey<Bool> {
//    /// A shared key for tracking whether the tab bar is hidden.
//    static var isTabBarHidden: InMemoryKey<Bool> {
//        .inMemory("isTabBarHidden")
//    }
// }
