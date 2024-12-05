import AccountFeature
import ComposableArchitecture
import GuidesFeature
import NewsFeature
import Styleguide
import SwiftHelpers
import SwiftUI

@ViewAction(for: Tabs.self)
public struct TabsView: View {
    @Bindable public var store: StoreOf<Tabs>
    
    public init(store: StoreOf<Tabs>) {
        self.store = store
    }
    
    private let tabs: [TabBarItem] = [
        .init(tab: Tabs.State.Tab.guides, title: "Guides", resource: .guidesTab),
        .init(tab: Tabs.State.Tab.news, title: "News", resource: .newsTab),
        .init(tab: Tabs.State.Tab.donate, title: "Donate", resource: .donateTab),
        .init(tab: Tabs.State.Tab.account, title: "Account", resource: .accountTab)
    ]
    
    public var body: some View {
        CustomTabViewContainer(tabs: tabs, selectedTab: self.$store.tab) {
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
