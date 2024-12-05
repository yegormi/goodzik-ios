import ComposableArchitecture
import Foundation
import Styleguide
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: Donate.self)
public struct DonateView: View {
    @Bindable public var store: StoreOf<Donate>

    public init(store: StoreOf<Donate>) {
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
    DonateView(store: Store(initialState: Donate.State()) {
        Donate()
    })
}
