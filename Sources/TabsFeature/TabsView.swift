import AccountFeature
import ComposableArchitecture
import DonateFeature
import GuidesFeature
import NewsFeature
import Styleguide
import SwiftHelpers
import SwiftUI
import SwiftUIHelpers

extension Tabs.State.Tab: TabBarItem {
    public var title: LocalizedStringKey {
        switch self {
        case .news:
            "News"
        case .guides:
            "Guides"
        case .account:
            "Account"
        case .donate:
            "Donate"
        }
    }

    public var icon: Image {
        switch self {
        case .news:
            Image(.newsTab)
        case .guides:
            Image(.guidesTab)
        case .account:
            Image(.accountTab)
        case .donate:
            Image(.donateTab)
        }
    }
}

@ViewAction(for: Tabs.self)
public struct TabsView: View {
    @Bindable public var store: StoreOf<Tabs>

    public init(store: StoreOf<Tabs>) {
        self.store = store
    }

    public var body: some View {
        TabBarContainer(items: [.news, .guides, .account, .donate], selection: self.$store.tab, config: .default) {
            NavigationStack {
                GuidesView(
                    store: self.store.scope(state: \.guides, action: \.guides)
                )
                .background(Color.tabBackground)
                .navigationTitle("Guides")
                .toolbarTitleDisplayMode(.inlineLarge)
            }
            .tag(Tabs.State.Tab.guides)

            NavigationStack {
                NewsView(
                    store: self.store.scope(state: \.news, action: \.news)
                )
                .background(Color.tabBackground)
                .navigationTitle("News")
                .toolbarTitleDisplayMode(.inlineLarge)
            }
            .tag(Tabs.State.Tab.news)

            NavigationStack {
                AccountView(
                    store: self.store.scope(state: \.account, action: \.account)
                )
                .background(Color.tabBackground)
                .navigationTitle("Account")
                .toolbarTitleDisplayMode(.inlineLarge)
            }
            .tag(Tabs.State.Tab.account)

            NavigationStack {
                DonateView(
                    store: self.store.scope(state: \.donate, action: \.donate)
                )
                .background(Color.tabBackground)
                .navigationTitle("Donate")
                .toolbarTitleDisplayMode(.inlineLarge)
            }
            .tag(Tabs.State.Tab.donate)
        }
    }
}

#Preview {
    TabsView(store: Store(initialState: Tabs.State()) {
        Tabs()
    })
}
