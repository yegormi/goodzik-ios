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
                if let guides = self.store.guides {
                    ForEach(guides) { guide in
                        Button {
                            send(.guideTapped(guide))
                        } label: {
                            GuideCardView(guide: guide)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentMargins(.all, 20, for: .scrollContent)
        .onFirstAppear {
            send(.onFirstAppear)
        }
        .onAppear {
            send(.onAppear)
        }
        .navigationDestination(
            item: self.$store.scope(
                state: \.destination?.guideDetail,
                action: \.destination.guideDetail
            )
        ) { store in
            GuideDetailView(store: store)
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
                .hideTabBar(true)
        }
    }
}

#Preview {
    GuidesView(store: Store(initialState: Guides.State()) {
        Guides()
    })
}
