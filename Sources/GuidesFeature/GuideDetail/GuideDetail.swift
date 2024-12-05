import APIClient
import ComposableArchitecture
import Foundation
import SharedModels

@Reducer
public struct GuideDetail: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        var guide: Guide
        var isNextButtonVisible = true

        public init(guide: Guide) {
            self.guide = guide
        }
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
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
            case nextButtonTapped
            case handleScroll(CGFloat)
        }
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

            case let .internal(.handleScroll(offset)):
                state.isNextButtonVisible = offset < 100
                return .none

            case .view(.binding):
                return .none

            case .view(.onFirstAppear):
                return .none

            case .view(.onAppear):
                return .none

            case .view(.nextButtonTapped):
                return .send(.delegate(.nextButtonTapped))

            case let .view(.handleScroll(offset)):
                return .send(.internal(.handleScroll(offset)))
            }
        }
    }
}
