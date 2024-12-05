import AccountFeature
import ComposableArchitecture
import GuidesFeature
import NewsFeature
import SwiftUI

@Reducer
public struct Tabs: Reducer {
    @ObservableState
    public struct State: Equatable {
        var tab = Tab.guides
        var guides = Guides.State()
        var news = News.State()
        var account = Account.State()
        var donate = Donate.State()

        public init() {}

        public enum Tab: Equatable {
            case guides
            case news
            case account
            case donate
        }
    }

    public enum Action: ViewAction {
        case guides(Guides.Action)
        case news(News.Action)
        case donate(Donate.Action)
        case account(Account.Action)

        case view(View)

        public enum View: BindableAction, Equatable {
            case binding(BindingAction<State>)
            case tabSelected(State.Tab)
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)

        Scope(state: \.guides, action: \.guides) {
            Guides()
        }

        Scope(state: \.news, action: \.news) {
            News()
        }

        Scope(state: \.donate, action: \.donate) {
            Donate()
        }

        Scope(state: \.account, action: \.account) {
            Account()
        }

        Reduce { state, action in
            switch action {
            case .guides:
                return .none

            case .news:
                return .none

            case .donate:
                return .none

            case .account:
                return .none
                
            case let .view(.tabSelected(tab)):
                state.tab = tab
                return .none

            case .view:
                return .none
            }
        }
    }
}
