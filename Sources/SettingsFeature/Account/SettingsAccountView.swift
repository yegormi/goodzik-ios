import ComposableArchitecture
import Foundation
import SharedModels
import Styleguide
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: SettingsAccount.self)
public struct SettingsAccountView: View {
    @Bindable public var store: StoreOf<SettingsAccount>

    public init(store: StoreOf<SettingsAccount>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 50) {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Profile")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Update your profile")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack { Divider().overlay(Color.secondary) }

                    VStack(spacing: 14) {
                        TextField("Email", text: self.$store.email)
                            .textFieldStyle(.auth)
                            .textContentType(.emailAddress)
                            .disabled(true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Button("Update") {
                        send(.updateButtonTapped)
                    }
                    .buttonStyle(.primary(size: .fullWidth))

                    Button("Reset") {
                        send(.resetButtonTapped)
                    }
                    .buttonStyle(.secondary(size: .fullWidth))
                }

                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Actions")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Manage your account")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack { Divider().overlay(Color.secondary) }

                    VStack(spacing: 20) {
                        Button("Sign out") {
                            send(.logoutButtonTapped)
                        }
                        .buttonStyle(.destructive(size: .fullWidth))

                        Button("Delete account") {
                            send(.deleteButtonTapped)
                        }
                        .font(.labelMedium)
                        .buttonStyle(.destructive(size: .fullWidth, variant: .outlined))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    SettingsAccountView(store: Store(initialState: SettingsAccount.State(user: .mock)) {
        SettingsAccount()
    })
}
