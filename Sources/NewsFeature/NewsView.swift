import ComposableArchitecture
import Foundation
import Styleguide
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: NewsFeature.self)
public struct NewsView: View {
    @Bindable public var store: StoreOf<NewsFeature>

    public init(store: StoreOf<NewsFeature>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let items = self.store.newsItems {
                    ForEach(items) { item in
                        Button {
                            send(.newsItemTapped(item))
                        } label: {
                            NewsCardView(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentMargins(.all, 20, for: .scrollContent)
        .navigationDestination(
            item: self.$store.scope(
                state: \.destination?.newsDetail,
                action: \.destination.newsDetail
            )
        ) { store in
            NewsDetailView(store: store)
                .navigationTitle("News Details")
                .navigationBarTitleDisplayMode(.inline)
                .hideTabBar(true)
        }
        .onAppear {
            send(.onAppear)
        }
    }
}

#Preview {
    NewsView(store: Store(initialState: NewsFeature.State()) {
        NewsFeature()
    })
}
