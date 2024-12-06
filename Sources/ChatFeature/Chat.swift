import APIClient
import ComposableArchitecture
import Foundation
import OSLog
import SessionClient
import SharedModels

@Reducer
public struct Chat: Reducer {
    @ObservableState
    public struct State: Equatable {
        var messages: [Message] = []
        var messageText = ""

        public init() {
//            self.messages = [
//                Message(text: "I've been thinking about going on a trip. Would you be interested?", isFromCurrentUser: false),
//                Message(text: "Where were you thinking of going?", isFromCurrentUser: true),
//                Message(text: "Maybe somewhere we haven't been before?", isFromCurrentUser: false),
//                Message(text: "Definitely 🤩👌", isFromCurrentUser: true),
//            ]
        }
    }

    public enum Action: ViewAction {
        case view(View)

        public enum View: BindableAction {
            case binding(BindingAction<State>)
            case sendMessage
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)

        Reduce { state, action in
            switch action {
            case .view(.binding):
                return .none

            case .view(.sendMessage):
                guard !state.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    return .none
                }

                let message = Message(text: state.messageText, isFromCurrentUser: true)
                state.messages.append(message)
                state.messageText = ""
                return .none
            }
        }
    }
}
