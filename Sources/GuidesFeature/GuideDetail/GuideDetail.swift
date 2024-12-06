import APIClient
import ChatFeature
import ComposableArchitecture
import Foundation
import SharedModels

@Reducer
public struct GuideDetail: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        @Presents var destination: Destination.State?
        var guide: Guide
        var isNextButtonVisible = true

        public init(guide: Guide) {
            self.guide = guide
        }
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {
            case nextButtonTapped
        }

        public enum Internal {
            case handleScroll(CGFloat)
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

    @Reducer(state: .equatable)
    public enum Destination {
        case guideSteps(GuideSteps)
        case chat(Chat)
    }

    @Dependency(\.apiClient) var api
    @Dependency(\.uuid) var uuid

    public init() {}

    public var body: some ReducerOf<Self> {
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

            case .view(.binding):
                return .none

            case .view(.onFirstAppear):
                return .none

            case .view(.onAppear):
                return .none

            case .view(.chatButtonTapped):
                state.destination = .chat(Chat.State())
                return .none

            case .view(.nextButtonTapped):
                state.destination = .guideSteps(GuideSteps.State(
                    steps: GuideStep.mocks
                ))
                return .none

            case let .view(.handleScroll(offset)):
                return .send(.internal(.handleScroll(offset)))
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
