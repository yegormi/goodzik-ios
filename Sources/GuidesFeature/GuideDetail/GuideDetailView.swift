import ChatFeature
import ComposableArchitecture
import Foundation
import Styleguide
import SwiftHelpers
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: GuideDetail.self)
public struct GuideDetailView: View {
    @Bindable public var store: StoreOf<GuideDetail>

    public init(store: StoreOf<GuideDetail>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(spacing: 24) {
                    self.imageView

                    VStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Author")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)

                            Text(self.store.guide.title)
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Divider()

                        Text(self.store.guide.description)
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }

                    Spacer(minLength: 100)
                }
                .overlay(
                    GeometryReader { proxy in
                        Color.clear.preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: proxy.frame(in: .named("scroll")).minY
                        )
                    }
                )
            }
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
            send(.handleScroll(offset))
        }
        .contentMargins(.all, 30, for: .scrollContent)
        .background(Color(uiColor: .systemGroupedBackground))
        .overlay(alignment: .bottomTrailing) {
            if self.store.isNextButtonVisible {
                HStack(spacing: 10) {
                    Button {
                        send(.chatButtonTapped)
                    } label: {
                        Image(.message)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.white)
                            .frame(width: 55, height: 55)
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)

                    Button {
                        send(.nextButtonTapped)
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(width: 55, height: 55)
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
                .safeAreaPadding(20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(duration: 0.3), value: self.store.isNextButtonVisible)
        .navigationDestination(
            item: self.$store.scope(
                state: \.destination?.guideSteps,
                action: \.destination.guideSteps
            )
        ) { store in
            GuideStepsView(store: store)
                .navigationTitle("Steps")
                .navigationBarTitleDisplayMode(.inline)
                .hideTabBar(true)
        }
        .sheet(
            item: self.$store.scope(
                state: \.destination?.chat,
                action: \.destination.chat
            )
        ) { store in
            NavigationStack {
                ChatView(store: store)
                    .navigationTitle("Chat")
                    .navigationBarTitleDisplayMode(.inline)
                    .hideTabBar(true)
            }
        }
        .onFirstAppear {
            send(.onFirstAppear)
        }
        .onAppear {
            send(.onAppear)
        }
    }

    private var imageView: some View {
        RoundedRectangle(cornerRadius: 20)
            .aspectRatio(contentMode: .fill)
            .overlay {
                AsyncImage(url: self.store.guide.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.1)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private struct ScrollOffsetPreferenceKey: @preconcurrency PreferenceKey {
    @MainActor static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
