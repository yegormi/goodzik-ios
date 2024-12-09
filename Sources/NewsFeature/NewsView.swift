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
                } else {
                    self.emptyContent
                }
            }
        }
        .refreshable {
            send(.onRefresh)
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
                .tabBarVisibility(false)
        }
        .onAppear {
            send(.onAppear)
        }
        .onFirstAppear {
            send(.onFirstAppear)
        }
    }

    private var emptyContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "newspaper")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(Color.textPrimary)

            VStack(spacing: 8) {
                Text("No News yet")
                    .foregroundColor(.textPrimary)
                    .font(.system(size: 20))
                    .bold()

                Text("No news yet, please check back later.")
                    .foregroundColor(.secondary)
                    .font(.system(size: 15))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NewsView(store: Store(initialState: NewsFeature.State()) {
        NewsFeature()
    })
}
