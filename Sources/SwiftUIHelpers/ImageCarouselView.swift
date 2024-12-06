import SwiftUI

public struct ImageCarouselView: View {
    public let imageURLs: [URL]
    @State private var currentIndex = 0

    public init(imageURLs: [URL]) {
        self.imageURLs = imageURLs
    }

    public var body: some View {
        TabView(selection: self.$currentIndex) {
            ForEach(Array(self.imageURLs.enumerated()), id: \.element) { _, url in
                GeometryReader { geometry in
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.opacity(0.2)
                        case let .success(image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Color.gray.opacity(0.2)
                                .overlay {
                                    Image(systemName: "photo")
                                        .foregroundStyle(.gray)
                                }
                        @unknown default:
                            Color.gray.opacity(0.2)
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 250)
    }
}
