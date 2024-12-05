import ComposableArchitecture
import Foundation
import Styleguide
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: AuthFeature.self)
public struct AuthView: View {
    @Bindable public var store: StoreOf<AuthFeature>

    public init(store: StoreOf<AuthFeature>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                HStack(spacing: 0) {
                    Image(.appLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 30)
                        .padding(8)
                    Text("Goodzik")
                        .font(.system(size: 20))
                        .bold()
                }

                Text(self.store.authType.title)
                    .font(.system(size: 36))
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .trailing, spacing: 14) {
                    if self.store.authType == .signUp {
                        TextField("Username", text: self.$store.username)
                            .textFieldStyle(.auth)
                            .textContentType(.name)
                    }

                    TextField("Email", text: self.$store.email)
                        .textFieldStyle(.auth)
                        .textContentType(.emailAddress)

                    PasswordField("Password", text: self.$store.password)
                        .textFieldStyle(.auth)
                        .textContentType(.password)

                    if self.store.authType == .signUp {
                        PasswordField("Confirm password", text: self.$store.confirmPassword)
                            .textFieldStyle(.auth)
                            .textContentType(.password)
                    }
                }

                Button {
                    if self.store.authType == .signIn {
                        send(.loginButtonTapped)
                    } else {
                        send(.signupButtonTapped)
                    }
                } label: {
                    Text(self.store.authType.title)
                }
                .buttonStyle(.primary(size: .fullWidth))
                .disabled(!self.store.isFormValid || self.store.isLoading)

                HStack(spacing: 5) {
                    Group {
                        Text(self.store.authType == .signIn ? "Don't have an account?" : "Already have an account?")
                        Text(self.store.authType == .signIn ? "Sign up" : "Log in")
                            .foregroundStyle(Color.orangePrimary)
                            .onTapGesture {
                                send(.toggleButtonTapped, animation: .spring(response: 0.5, dampingFraction: 0.7))
                            }
                    }
                    .font(.labelLarge)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(30)
        .isLoading(self.store.isLoading)
        .alert(self.$store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
}
