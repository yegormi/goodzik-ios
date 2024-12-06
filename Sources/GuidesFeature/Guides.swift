import APIClient
import ComposableArchitecture
import Foundation
import SharedModels

@Reducer
public struct Guides: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        @Presents var destination: Destination.State?
        var guides: [Guide]?

        public init() {}
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {}

        public enum Internal {
            case fetchGuidesResponse(Result<[Guide], Error>)
        }

        public enum View: BindableAction {
            case binding(BindingAction<Guides.State>)
            case onFirstAppear
            case onAppear
            case guideTapped(Guide)
        }
    }

    @Reducer(state: .equatable)
    public enum Destination {
        case guideDetail(GuideDetail)
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

            case .destination:
                return .none

            case let .internal(.fetchGuidesResponse(result)):
                switch result {
                case let .success(guides):
                    state.guides = guides
                case .failure:
                    break
                }

                return .none

            case .view(.binding):
                return .none

            case .view(.onFirstAppear):
                return .none

            case .view(.onAppear):
                return self.fetchGuides()

            case let .view(.guideTapped(guide)):
                state.destination = .guideDetail(GuideDetail.State(guide: guide))

                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func fetchGuides() -> Effect<Action> {
        .run { send in
            await send(.internal(.fetchGuidesResponse(Result {
                try await self.api.getGuides()
            })))
        }
    }
}
