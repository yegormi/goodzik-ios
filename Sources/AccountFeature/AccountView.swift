import ComposableArchitecture
import Foundation
import SharedModels
import Styleguide
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: Account.self)
public struct AccountView: View {
    @Bindable public var store: StoreOf<Account>

    public init(store: StoreOf<Account>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 6) {
                    Text(self.store.user.username)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(Color.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(self.store.user.email)
                        .font(.system(size: 14, weight: .semibold))
                        .tint(Color.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(spacing: 16) {
                    MenuButton(
                        title: "About us",
                        image: .aboutUs,
                        tint: .primary
                    ) {
                        send(.aboutUsButtonTapped)
                    }
                    MenuButton(
                        title: "Logout",
                        image: .logout,
                        tint: .red500
                    ) {
                        send(.logoutButtonTapped)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 8, y: 5)
            )
        }
        .contentMargins(.all, 16, for: .scrollContent)
        .onAppear {
            send(.onAppear)
        }
        .isLoading(self.store.isLoading)
        .alert(
            store: self.store.scope(state: \.$destination.alert, action: \.destination.alert)
        )
        .alert(
            store: self.store.scope(state: \.$destination.plainAlert, action: \.destination.plainAlert)
        )
    }
}

#Preview {
    AccountView(store: Store(initialState: Account.State()) {
        Account()
    })
}
