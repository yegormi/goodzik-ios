import APIClient
import ComposableArchitecture
import Foundation
import SharedModels

@Reducer
public struct GuideDetail: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        var guide: Guide
        
        public init(guide: Guide) {
            self.guide = guide
        }
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {}

        public enum Internal {}

        public enum View: BindableAction {
            case binding(BindingAction<GuideDetail.State>)
            case onFirstAppear
            case onAppear
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

            case .internal:
                return .none

            case .view(.binding):
                return .none

            case .view(.onFirstAppear):
                return .none

            case .view(.onAppear):
                return .none
            }
        }
    }
}
