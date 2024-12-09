import ComposableArchitecture
import Foundation
import Styleguide
import SwiftHelpers
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: Guides.self)
public struct GuidesView: View {
    @Bindable public var store: StoreOf<Guides>

    public init(store: StoreOf<Guides>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let guides = self.store.guides {
                    ForEach(guides) { guide in
                        Button {
                            send(.guideTapped(guide))
                        } label: {
                            GuideCardView(guide: guide)
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    self.emptyContent
                }
            }
        }
        .refreshable {
            send(.onRefresh)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentMargins(.all, 20, for: .scrollContent)
        .onFirstAppear {
            send(.onFirstAppear)
        }
        .onAppear {
            send(.onAppear)
        }
        .navigationDestination(
            item: self.$store.scope(
                state: \.destination?.guideDetail,
                action: \.destination.guideDetail
            )
        ) { store in
            GuideDetailView(store: store)
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
                .tabBarVisibility(false)
        }
    }

    private var emptyContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "rectangle.grid.2x2")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(Color.textPrimary)

            VStack(spacing: 8) {
                Text("No Guides yet")
                    .foregroundColor(.textPrimary)
                    .font(.system(size: 20))
                    .bold()

                Text("No guides yet, please check back later.")
                    .foregroundColor(.secondary)
                    .font(.system(size: 15))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    GuidesView(store: Store(initialState: Guides.State()) {
        Guides()
    })
}
