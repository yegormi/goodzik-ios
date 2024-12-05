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
        VStack {
            EmptyTabView()
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
