import APIClient
import ChatFeature
import ComposableArchitecture
import Foundation
import SharedModels

@Reducer
public struct GuideDetail: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        @Presents var destination: Destination.State?
        var guide: Guide
        var isNextButtonVisible = true
        var chat = Chat.State()

        var guideDetails: GuideDetails?

        public init(guide: Guide) {
            self.guide = guide
        }
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)
        case chat(Chat.Action)

        public enum Delegate {
            case nextButtonTapped
        }

        public enum Internal {
            case handleScroll(CGFloat)
            case guideDetailsResponse(Result<GuideDetails, Error>)
        }

        public enum View: BindableAction {
            case binding(BindingAction<GuideDetail.State>)
            case onFirstAppear
            case onAppear
            case chatButtonTapped
            case nextButtonTapped
            case handleScroll(CGFloat)
        }
    }

    @Reducer(state: .equatable, .sendable)
    public enum Destination {
        case guideSteps(GuideSteps)
        case chat(Chat)
    }

    @Dependency(\.apiClient) var api
    @Dependency(\.uuid) var uuid

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.chat, action: \.chat) {
            Chat()
        }

        BindingReducer(action: \.view)

        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case .destination(.presented(.guideSteps(.delegate(.finished)))):
                return .send(.delegate(.nextButtonTapped))

            case .destination:
                return .none

            case let .internal(.handleScroll(offset)):
                state.isNextButtonVisible = offset > -10
                return .none

            case let .internal(.guideDetailsResponse(result)):
                switch result {
                case let .success(details):
                    state.guideDetails = details
                case .failure:
                    break
                }
                return .none

            case .view(.binding):
                return .none

            case .view(.onFirstAppear):
                return self.fetchGuideDetails(&state)

            case .view(.onAppear):
                return .none

            case .view(.chatButtonTapped):
                state.destination = .chat(Chat.State())
                return .none

            case .view(.nextButtonTapped):
                guard let steps = state.guideDetails?.steps else {
                    return .none
                }

                state.destination = .guideSteps(GuideSteps.State(steps: steps))
                return .none

            case let .view(.handleScroll(offset)):
                return .send(.internal(.handleScroll(offset)))

            case .chat:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func fetchGuideDetails(_ state: inout State) -> Effect<Action> {
        .run { [state] send in
            await send(.internal(.guideDetailsResponse(Result {
                try await self.api.getGuide(state.guide.id)
            })))
        }
    }
}
