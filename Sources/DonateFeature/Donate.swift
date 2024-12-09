import ComposableArchitecture
import Foundation
import UIKit

@Reducer
public struct Donate: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        @Presents var destination: Destination.State?
        var copiedCardNumber = false

        public init() {}
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)

        public enum Delegate: Equatable {}

        public enum Internal: Equatable {
            case cardNumberCopied
            case clearCopiedStatus
        }

        public enum View: Equatable, BindableAction {
            case binding(BindingAction<Donate.State>)
            case onAppear
            case monoJarButtonTapped
            case payPalButtonTapped
            case copyCardButtonTapped
        }
    }

    @Reducer(state: .equatable)
    public enum Destination {}

    private enum CancelID {
        case copiedTimer
    }

    @Dependency(\.openURL) var openURL

    @Dependency(\.suspendingClock) var clock

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)

        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case .destination:
                return .none

            case .internal(.cardNumberCopied):
                state.copiedCardNumber = true
                return .run { send in
                    await UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    try await self.clock.sleep(for: .seconds(1))
                    await send(.internal(.clearCopiedStatus))
                }
                .cancellable(id: CancelID.copiedTimer)

            case .internal(.clearCopiedStatus):
                state.copiedCardNumber = false
                return .none

            case .view(.binding):
                return .none

            case .view(.onAppear):
                return .none

            case .view(.monoJarButtonTapped):
                guard let url = URL(string: "https://send.monobank.ua/jar/5VV7zhDJGY") else {
                    return .none
                }
                return .run { _ in
                    await self.openURL(url)
                }

            case .view(.payPalButtonTapped):
                guard
                    let url =
                    URL(
                        string: "https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&bn=AngellEYE_PHPClass&business=marishka.polo@gmail.com"
                    )
                else {
                    return .none
                }
                return .run { _ in
                    await self.openURL(url)
                }

            case .view(.copyCardButtonTapped):
                UIPasteboard.general.string = "5375411203817304"
                return .send(.internal(.cardNumberCopied))
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
