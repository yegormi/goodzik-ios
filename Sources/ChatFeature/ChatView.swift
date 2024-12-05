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
                }
                .onChange(of: self.store.messages) { _, newMessages in
                    guard let lastMessageId = newMessages.last?.id else { return }
                    withAnimation {
                        proxy.scrollTo(lastMessageId, anchor: .bottom)
                    }
                }
            }

            self.inputView
        }
        .padding(20)
        .background(Color.tabBackground)
    }

    private var inputView: some View {
        HStack(spacing: 10) {
            TextField("Write a message...", text: self.$store.messageText, axis: .vertical)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(uiColor: .systemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .focused(self.$isFocused)

            Button {
                send(.sendMessage)
            } label: {
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
        .padding(.vertical, 8)
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
