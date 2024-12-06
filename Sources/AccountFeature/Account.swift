import APIClient
import ComposableArchitecture
import Foundation
import OSLog
import SessionClient
import SharedModels

private let logger = Logger(subsystem: "AccountFeature", category: "Account")

@Reducer
public struct Account: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        @Presents var destination: Destination.State?

        var user: User
        var isLoading = false

        public init() {
            @Dependency(\.session) var session
            self.user = session.unsafeCurrentUser
        }
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {}

        public enum Internal {
            case logoutResult(Result<Void, Error>)
        }

        public enum View: Equatable, BindableAction {
            case binding(BindingAction<Account.State>)
            case onAppear
            case aboutUsButtonTapped
            case logoutButtonTapped
        }
    }

    @Reducer(state: .equatable, .sendable)
    public enum Destination {
        case alert(AlertState<Alert>)
        case plainAlert(AlertState<Never>)

        public enum Alert: Equatable, Sendable {
            case logoutTapped
        }
    }

    @Dependency(\.apiClient) var api

    @Dependency(\.session) var session

    @Dependency(\.openURL) var openURL

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)

        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case .destination(.presented(.alert(.logoutTapped))):
                return self.logout(&state)

            case .destination:
                return .none

            case let .internal(.logoutResult(result)):
                state.isLoading = false

                if case let .failure(error) = result {
                    logger.warning("Failed to log out, error: \(error)")
                    state.destination = .plainAlert(.failed(error))
                }
                return .none

            case .view(.binding):
                return .none

            case .view(.onAppear):
                return .none

            case .view(.aboutUsButtonTapped):
                return .run { _ in
                    await self.openURL(URL(string: "https://goodzik-landing-9akk.vercel.app/")!)
                }

            case .view(.logoutButtonTapped):
                state.destination = .alert(.signOutAccount)
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
}

extension AlertState where Action == Account.Destination.Alert {
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
