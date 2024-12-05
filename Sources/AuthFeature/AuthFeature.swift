import APIClient
import ComposableArchitecture
import CryptoKit
import FacebookClient
import FacebookCore
import FacebookLogin
import Foundation
import GoogleClient
import GoogleSignIn
import KeychainClient
import OSLog
import SessionClient
import SharedModels
import SwiftHelpers

private let logger = Logger(subsystem: "AuthenticationFeature", category: "Auth")

@Reducer
public struct AuthFeature: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        public init() {}

        var authType: AuthType = .signIn
        var username = ""
        var email = ""
        var password = ""
        var confirmPassword = ""
        var isLoading = false
        @Presents var destination: Destination.State?
        
        var isFormValid: Bool {
            switch self.authType {
            case .signIn:
                self.email.isValidEmail && !self.password.isEmpty
            case .signUp:
                !self.username.isEmpty && self.email.isValidEmail &&
                !self.password.isEmpty && self.password == self.confirmPassword
            }
        }
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {
            case authSuccessful
        }

        public enum Internal {
            case localAuthResponse(Result<Void, Error>)
            case authResponse(Result<AuthResponse, Error>)
        }

        public enum View: BindableAction {
            case binding(BindingAction<AuthFeature.State>)
            case toggleButtonTapped
            case loginButtonTapped
            case signupButtonTapped
        }
    }

    @Reducer(state: .equatable, .sendable, action: .equatable, .sendable)
    public enum Destination {
        case alert(AlertState<Never>)
    }

    @Dependency(\.apiClient) var api

    @Dependency(\.session) var session

    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)

        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case .destination:
                return .none

            case let .internal(.localAuthResponse(result)):
                switch result {
                case .success:
                    logger.info("Authenticated the user successfully!")
                    return .send(.delegate(.authSuccessful))
                case let .failure(error):
                    logger.error("Failed to perform an action, error: \(error)")
                    state.destination = .alert(.failedToAuth(error: error))
                    return .none
                }

            case let .internal(.authResponse(result)):
                state.isLoading = false

                switch result {
                case let .success(response):
                    return .run { send in
                        await send(.internal(.localAuthResponse(Result {
                            try self.session.setCurrentAccessToken(response.accessToken)
                            let user = try await self.api.getCurrentUser()
                            self.session.authenticate(user)
                        })))
                    }
                case let .failure(error):
                    logger.error("Failed with error: \(error)")
                    state.destination = .alert(.failedToAuth(error: error))
                    return .none
                }

            case .view(.binding):
                return .none

            case .view(.toggleButtonTapped):
                state.authType.toggle()
                state.confirmPassword = ""
                return .none

            case .view(.loginButtonTapped):
                return self.login(&state)

            case .view(.signupButtonTapped):
                return self.signup(&state)
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func login(_ state: inout State) -> Effect<Action> {
        guard state.isFormValid, !state.isLoading else { return .none }
        state.isLoading = true

        return .run { [state] send in
            await send(.internal(.authResponse(Result {
                let request = LoginRequest(email: state.email, password: state.password)
                return try await self.api.login(request)
            })))
        }
    }

    private func signup(_ state: inout State) -> Effect<Action> {
        guard state.isFormValid, !state.isLoading else { return .none }
        state.isLoading = true

        return .run { [state] send in
            await send(.internal(.authResponse(Result {
                let request = SignupRequest(
                    userName: state.username,
                    email: state.email,
                    password: state.password
                )
                return try await self.api.signup(request)
            })))
        }
    }
}

extension AlertState where Action == Never {
    static func failedToAuth(error: any Error) -> Self {
        Self {
            TextState("Failed to authenticate")
        } actions: {
            ButtonState(role: .cancel) {
                TextState("OK")
            }
        } message: {
            TextState(error.localizedDescription)
        }
    }
}

extension Error {
    var isUserCancelled: Bool {
        if let googleError = self as? GIDSignInError, googleError.code == .canceled { return true }
        if let fbError = self as? FacebookAuthError, fbError == .canceled { return true }
        return false
    }
}
