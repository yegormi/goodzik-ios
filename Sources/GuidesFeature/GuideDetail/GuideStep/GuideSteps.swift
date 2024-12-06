import ComposableArchitecture
import Foundation
import SharedModels

@Reducer
public struct GuideSteps: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        var steps: [GuideStep]
        var currentIndex: Int
        var isLastStep: Bool { self.currentIndex == self.steps.count - 1 }

        public init(steps: [GuideStep], currentIndex: Int = 0) {
            self.steps = steps
            self.currentIndex = currentIndex
        }
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case view(View)

        public enum Delegate {
            case finished
        }

        public enum View {
            case nextTapped
            case previousTapped
            case pageChanged(Int)
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case .view(.nextTapped):
                if state.isLastStep {
                    return .send(.delegate(.finished))
                } else {
                    state.currentIndex += 1
                    return .none
                }

            case .view(.previousTapped):
                guard state.currentIndex > 0 else { return .none }
                state.currentIndex -= 1
                return .none

            case let .view(.pageChanged(index)):
                state.currentIndex = index
                return .none
            }
        }
    }
}
