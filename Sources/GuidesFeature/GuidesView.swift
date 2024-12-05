import ComposableArchitecture
import Foundation
import Styleguide
import SwiftHelpers
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: Guides.self)
public struct GuidesView: View {
    @Bindable public var store: StoreOf<Guides>

    public init(store: StoreOf<Guides>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(self.store.guides) { guide in
                    Button {
                        send(.guideTapped(guide))
                    } label: {
                        GuideCardView(guide: guide)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .contentMargins(.all, 20, for: .scrollContent)
        .navigationDestination(
            item: self.$store.scope(state: \.destination?.guideDetail, action: \.destination.guideDetail)
        ) { store in
            GuideDetailView(store: store)
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
                .hideTabBar()
        }
        .onFirstAppear {
            send(.onFirstAppear)
        }
        .onAppear {
            send(.onAppear)
        }
    }
}

#Preview {
    GuidesView(store: Store(initialState: Guides.State()) {
        Guides()
    })
}
