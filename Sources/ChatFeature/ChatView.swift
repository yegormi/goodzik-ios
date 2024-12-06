import ComposableArchitecture
import Foundation
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
            if self.store.messages.isEmpty {
                self.emptyContent
            } else {
                self.chatContent
            }

            self.messageInput
        }
        .padding(.horizontal, 20)
    }

    private var chatContent: some View {
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
            }
            .onChange(of: self.store.messages) { _, newMessages in
                guard let lastMessageId = newMessages.last?.id else { return }
                withAnimation {
                    proxy.scrollTo(lastMessageId, anchor: .bottom)
                }
            }
        }
    }

    private var emptyContent: some View {
        VStack(spacing: 12) {
            Image(.message)
                .foregroundStyle(Color.textPrimary)

            VStack(spacing: 8) {
                Text("No Messages yet")
                    .foregroundColor(.textPrimary)
                    .font(.system(size: 20))
                    .bold()

                Text("No messages yet, start the chat")
                    .foregroundColor(.secondary)
                    .font(.system(size: 15))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var messageInput: some View {
        HStack(spacing: 10) {
            TextField("Write a message...", text: self.$store.messageText, axis: .vertical)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.tabBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .focused(self.$isFocused)

            self.sendButton
        }
        .padding(.vertical, 8)
    }

    private var sendButton: some View {
        Button(action: { send(.sendMessage) }) {
            Image(.send)
                .padding(5)
                .background(
                    Circle()
                        .fill(Color.messageOutgoing)
                )
                .clipShape(Circle())
        }
        .disabled(self.store.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
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
    .scrollIndicators(.never)
}
