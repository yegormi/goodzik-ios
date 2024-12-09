import SwiftUI

enum PreviewTab: TabBarItem {
    case home
    case search
    case favorites
    case profile

    var title: LocalizedStringKey {
        switch self {
        case .home: "Home"
        case .search: "Search"
        case .favorites: "Favorites"
        case .profile: "Profile"
        }
    }

    var icon: some View {
        switch self {
        case .home:
            Image(systemName: "house.fill")
        case .search:
            Image(systemName: "magnifyingglass")
        case .favorites:
            Image(systemName: "heart.fill")
        case .profile:
            Image(systemName: "person.fill")
        }
    }

    var badgeCount: Int? {
        switch self {
        case .favorites: 5
        case .profile: 2
        default: nil
        }
    }
}

struct TabBarPreview: View {
    @State private var selectedTab: PreviewTab = .home

    var body: some View {
        TabBarContainer(
            items: [.home, .search, .favorites, .profile],
            selection: self.$selectedTab,
            config: .default
        ) {
            Color.red
                .overlay(Text("Home View"))
                .tag(PreviewTab.home)

            Color.blue
                .overlay(Text("Search View"))
                .tag(PreviewTab.search)

            Color.green
                .overlay(Text("Favorites View"))
                .tag(PreviewTab.favorites)

            Color.purple
                .overlay(Text("Profile View"))
                .tag(PreviewTab.profile)
        }
    }
}

// Custom theme example
struct CustomTheme: TabBarTheme {
    var containerBackground: some ShapeStyle {
        Color.black.opacity(0.8)
    }

    var containerShape: some Shape {
        RoundedRectangle(cornerRadius: 20)
    }

    var activeItemShape: some Shape {
        RoundedRectangle(cornerRadius: 15)
    }

    var activeItemColor: Color { .white }
    var inactiveItemColor: Color { .gray }
    var activeItemBackgroundColor: Color { .blue }
    var badgeStyle: TabBarBadgeStyle {
        TabBarBadgeStyle(
            backgroundColor: .red,
            foregroundColor: .white,
            font: .system(size: 12, weight: .bold),
            padding: EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6)
        )
    }
}

// Preview with custom theme
struct CustomTabBarPreview: View {
    @State private var selectedTab: PreviewTab = .home

    private var customConfig: TabBarConfiguration<CustomTheme> {
        TabBarConfiguration(
            theme: CustomTheme(),
            layout: TabBarLayout(
                itemSize: CGSize(width: 60, height: 60),
                iconSize: CGSize(width: 24, height: 24),
                itemSpacing: 12,
                labelSpacing: 4,
                contentPadding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
                safeAreaPadding: EdgeInsets(top: 0, leading: 20, bottom: 34, trailing: 20)
            ),
            animation: .default,
            haptics: .impact(.medium),
            showLabels: true,
            labelFont: .system(size: 12, weight: .medium)
        )
    }

    var body: some View {
        TabBarContainer(
            items: [.home, .search, .favorites, .profile],
            selection: self.$selectedTab,
            config: self.customConfig
        ) {
            Color.red
                .overlay(Text("Home View").foregroundColor(.white))
                .tag(PreviewTab.home)

            Color.blue
                .overlay(Text("Search View").foregroundColor(.white))
                .tag(PreviewTab.search)

            Color.green
                .overlay(Text("Favorites View").foregroundColor(.white))
                .tag(PreviewTab.favorites)

            Color.purple
                .overlay(Text("Profile View").foregroundColor(.white))
                .tag(PreviewTab.profile)
        }
    }
}

#Preview("Default Theme") {
    TabBarPreview()
}

#Preview("Custom Theme") {
    CustomTabBarPreview()
}
