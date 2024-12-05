import ComposableArchitecture
import Foundation
import Styleguide
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: News.self)
public struct NewsView: View {
    @Bindable public var store: StoreOf<News>
    
    public init(store: StoreOf<News>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(self.store.newsItems) { item in
                    Button {
                        send(.newsItemTapped(item))
                    } label: {
                        NewsItemCardView(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .navigationDestination(
            item: self.$store.scope(
                state: \.destination?.newsDetail,
                action: \.destination.newsDetail
            )
        ) { store in
            NewsDetailView(store: store)
                .navigationTitle("News Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden, for: .tabBar)
                .toolbarRole(.editor)
        }
        .onAppear {
            send(.onAppear)
        }
    }
}

#Preview {
    NewsView(store: Store(initialState: News.State()) {
        News()
    })
}
