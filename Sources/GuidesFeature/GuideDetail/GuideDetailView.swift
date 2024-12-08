import ChatFeature
import ComposableArchitecture
import Foundation
import Styleguide
import SwiftHelpers
import SwiftUI
import SwiftUIHelpers
import YouTubePlayerKit

@ViewAction(for: GuideDetail.self)
public struct GuideDetailView: View {
    @Bindable public var store: StoreOf<GuideDetail>

    public init(store: StoreOf<GuideDetail>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(self.store.guide.title)
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(Color.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Divider()

                        VideoPlayerView(videoURL: self.store.guide.videoURL?.absoluteString ?? "")
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Examples of schemas")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.primary)

                        Divider()

                        if let urls = self.store.guide.exampleImageURLs, !urls.isEmpty {
                            ImageCarouselView(imageURLs: urls)
                        }
                    }

                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Details")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.primary)

                            Divider()

                            Text(self.store.guide.description)
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Author")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.primary)

                            Divider()

                            Text(self.store.guide.author.username)
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comments")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.primary)

                            Divider()

                            ChatView(
                                store: self.store.scope(
                                    state: \.chat,
                                    action: \.chat
                                )
                            )
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                        }
                    }
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
                .tabBarVisibility(.hidden)
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
                    .tabBarVisibility(.hidden)
            }
        }
        .onFirstAppear {
            send(.onFirstAppear)
        }
        .onAppear {
            send(.onAppear)
        }
    }
}

private struct ScrollOffsetPreferenceKey: @preconcurrency PreferenceKey {
    @MainActor static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct VideoPlayerView: View {
    let videoURL: String

    @StateObject private var youTubePlayer: YouTubePlayer

    init(videoURL: String) {
        self.videoURL = videoURL
        self._youTubePlayer = StateObject(wrappedValue: YouTubePlayer(stringLiteral: videoURL))
    }

    var body: some View {
        YouTubePlayerView(self.youTubePlayer) { state in
            switch state {
            case .idle:
                ProgressView()
            case .ready:
                EmptyView()
            case .error:
                Text(verbatim: "YouTube player couldn't be loaded")
            }
        }
    }
}
