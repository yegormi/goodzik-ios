import ComposableArchitecture
import Foundation
import Styleguide
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: NewsDetail.self)
public struct NewsDetailView: View {
    @Bindable public var store: StoreOf<NewsDetail>

    public init(store: StoreOf<NewsDetail>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let urls = self.store.item.imageURls, !urls.isEmpty {
                    ImageCarouselView(imageURLs: urls)
                }

                Text(self.store.item.title)
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(self.store.item.date.formatted())
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(self.store.item.description)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if !self.store.item.categories.isEmpty {
                    self.categoriesView
                }
            }
            .padding(20)
        }
        .onAppear {
            send(.onAppear)
        }
    }

    private var categoriesView: some View {
        HStack(spacing: 8) {
            ForEach(self.store.item.categories) { category in
                Text(category.name)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.green500)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.green500.opacity(0.2))
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
