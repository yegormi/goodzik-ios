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
                    GuideCardView(guide: guide)
                }
            }
        }
        .contentMargins(.all, 20, for: .scrollContent)
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
