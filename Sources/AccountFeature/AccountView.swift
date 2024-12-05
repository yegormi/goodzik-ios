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
                        tint: .primary,
                        action: { /* action */ }
                    )
                    MenuButton(
                        title: "About us",
                        image: .aboutUs,
                        tint: .primary,
                        action: { /* action */ }
                    )
                    MenuButton(
                        title: "Logout",
                        image: .logout,
                        tint: .red500,
                        action: { /* action */ }
                    )
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    send(.settingsButtonTapped)
                } label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .padding(13)
                        .clipShape(Circle())
                }
            }
        }
        .navigationDestination(
            item: self.$store.scope(state: \.destination?.settings, action: \.destination.settings)
        ) { store in
            SettingsView(store: store)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func avatarCell(for user: SharedModels.User) -> some View {
        HStack(spacing: 12) {
            self.userAvatar(for: user)
                .frame(width: 70, height: 70)
            VStack(alignment: .leading, spacing: 5) {
                Text(user.fullName ?? "No username provided")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.primary)
                Text(user.email ?? "No email registered")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.neutral500)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func contentView(for tab: Account.State.Tab) -> some View {
        switch tab {
        case .events:
            self.eventsContent()
        case .tickets:
            self.ticketsContent()
        case .reviews:
            self.reviewsContent()
        }
    }

    @ViewBuilder
    private func eventsContent() -> some View {
        VStack {
            Text("My events")
                .font(.headlineSmall)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    @ViewBuilder
    private func ticketsContent() -> some View {
        VStack {
            Text("My tickets")
                .font(.headlineSmall)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    @ViewBuilder
    private func reviewsContent() -> some View {
        VStack {
            Text("My reviews")
                .font(.headlineSmall)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    @ViewBuilder
    private func userAvatar(for user: SharedModels.User) -> some View {
        if let pictureURL = user.photoURL {
            AsyncImage(url: pictureURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } placeholder: {
                self.placeholderAvatar(for: user)
            }
        } else {
            self.placeholderAvatar(for: user)
        }
    }

    private func placeholderAvatar(for user: User) -> some View {
        Circle()
            .foregroundStyle(Color.neutral200)
            .overlay {
                Text(user.fullName?.first?.uppercased() ?? "")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(Color.neutral500)
            }
    }
}

#Preview {
    AccountView(store: Store(initialState: Account.State()) {
        Account()
    })
}
