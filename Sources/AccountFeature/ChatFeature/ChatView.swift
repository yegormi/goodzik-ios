import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import Styleguide
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: Chat.self)
public struct ChatView: View {
    @Bindable public var store: StoreOf<Chat>
    @FocusState private var isFocused: Bool

    public init(store: StoreOf<Chat>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(self.store.messages) { message in
                            MessageBubble(
                                text: message.text,
                                date: message.date,
                                isFromCurrentUser: message.isFromCurrentUser
                            )
                            .id(message.id)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .onChange(of: self.store.messages) { _, newValue in
                    guard let lastMessageId = newValue.last?.id else { return }
                    withAnimation {
                        proxy.scrollTo(lastMessageId, anchor: .bottom)
                    }
                }
            }

            self.inputView
        }
        .background(Color.tabBackground)
    }

    private var inputView: some View {
        HStack(spacing: 10) {
            TextField("Write a message...", text: self.$store.messageText, axis: .vertical)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(uiColor: .systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .focused(self.$isFocused)

            Button {
                send(.sendMessage)
            } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Color.accentColor)
                    .clipShape(Circle())
            }
            .disabled(self.store.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

#Preview {
    ChatView(
        store: Store(
            initialState: Chat.State()
        ) {
            Chat()
        }
    )
}
