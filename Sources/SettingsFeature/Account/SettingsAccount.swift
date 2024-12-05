import APIClient
import ComposableArchitecture
import Foundation
import OSLog
import SessionClient
import SharedModels

private let logger = Logger(subsystem: "SettingsAccountFeature", category: "SettingsAccount")

@Reducer
public struct SettingsAccount: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        public enum Tab: Equatable, Sendable {
            case general, account, security
        }

        @Presents var destination: Destination.State?

        var user: User
        var tab = Tab.general

        var email: String

        var isLoading = false

        public init(user: User) {
            self.user = user
            self.email = user.email
        }
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)

        public enum Delegate: Equatable {}

        public enum Internal {
            case updateResponse(Result<Void, Error>)
            case logoutResult(Result<Void, Error>)
            case deleteResponse(Result<Void, Error>)
        }

        public enum View: Equatable, BindableAction {
            case binding(BindingAction<SettingsAccount.State>)
            case onAppear
            case updateButtonTapped
            case logoutButtonTapped
            case resetButtonTapped
            case deleteButtonTapped
        }
    }

    @Reducer(state: .equatable, .sendable)
    public enum Destination {
        case alert(AlertState<Alert>)
        case plainAlert(AlertState<Never>)

        public enum Alert: Equatable, Sendable {
            case logoutTapped
            case deleteTapped
        }
    }

    @Dependency(\.apiClient) var api

    @Dependency(\.session) var session

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)

        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case .destination(.presented(.alert(.logoutTapped))):
                return self.logout(&state)

            case .destination(.presented(.alert(.deleteTapped))):
                return self.deleteAccount(&state)

            case .destination:
                return .none

            case let .internal(.updateResponse(result)):
                return .none

            case let .internal(.logoutResult(result)):
                state.isLoading = false

                if case let .failure(error) = result {
                    logger.warning("Failed to log out, error: \(error)")
                    state.destination = .plainAlert(.failed(error))
                }
                return .none

            case let .internal(.deleteResponse(result)):
                state.isLoading = false

                switch result {
                case .success:
                    return self.logout(&state)
                case let .failure(error):
                    logger.warning("Failed to delete the account, error: \(error)")
                    state.destination = .plainAlert(.failed(error))
                }
                return .none

            case .view(.binding):
                return .none

            case .view(.onAppear):
                return .none

            case .view(.updateButtonTapped):
                return .none

            case .view(.resetButtonTapped):
                return .none

            case .view(.logoutButtonTapped):
                state.destination = .alert(.signOutAccount)
                return .none

            case .view(.deleteButtonTapped):
                state.destination = .alert(.deleteAccount)
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func logout(_ state: inout State) -> Effect<Action> {
        guard !state.isLoading else { return .none }
        state.isLoading = true

        return .run { send in
            await send(.internal(.logoutResult(Result {
                try self.session.logout()
            })))
        }
    }

    private func deleteAccount(_ state: inout State) -> Effect<Action> {
        guard !state.isLoading else { return .none }
        state.isLoading = true

        return .run { send in
            await send(.internal(.deleteResponse(Result {
//                try await self.api.deleteCurrentUser()
            })))
        }
    }
}

extension AlertState where Action == SettingsAccount.Destination.Alert {
    static let signOutAccount = Self {
        TextState("Confirm")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("Cancel")
        }
        ButtonState(role: .destructive, action: .logoutTapped) {
            TextState("Sign out")
        }
    } message: {
        TextState("Are you sure you want to sign out? This action cannot be undone.")
    }
}

extension AlertState where Action == SettingsAccount.Destination.Alert {
    static let deleteAccount = Self {
        TextState("Confirm")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("Cancel")
        }
        ButtonState(role: .destructive, action: .deleteTapped) {
            TextState("Delete")
        }
    } message: {
        TextState("Are you sure you want to delete your account? This action cannot be undone.")
    }
}

extension AlertState where Action == Never {
    static func failed(_ error: any Error) -> Self {
        Self {
            TextState("Failed to perform action")
        } actions: {
            ButtonState(role: .cancel) {
                TextState("OK")
            }
        } message: {
            TextState(error.localizedDescription)
        }
    }
}
