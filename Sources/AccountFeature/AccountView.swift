import ComposableArchitecture
import Foundation
import SettingsFeature
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
                    Text("Username")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(Color.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("mail@gmail.com")
                        .font(.system(size: 14, weight: .semibold))
                        .tint(Color.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(spacing: 16) {
                    MenuButton(
                        title: "Chats history",
                        image: .chat,
                        tint: .primary
                    ) { /* action */ }
                    MenuButton(
                        title: "About us",
                        image: .aboutUs,
                        tint: .primary
                    ) { /* action */ }
                    MenuButton(
                        title: "Logout",
                        image: .logout,
                        tint: .red500
                    ) { /* action */ }
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
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button {
//                    send(.settingsButtonTapped)
//                } label: {
//                    Image(systemName: "gearshape.fill")
//                        .resizable()
//                        .frame(width: 22, height: 22)
//                        .padding(13)
//                        .clipShape(Circle())
//                }
//            }
//        }
        .navigationDestination(
            item: self.$store.scope(state: \.destination?.settings, action: \.destination.settings)
        ) { store in
            SettingsView(store: store)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AccountView(store: Store(initialState: Account.State()) {
        Account()
    })
}
