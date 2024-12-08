import SharedModels
import SwiftUI
import SwiftUIHelpers

public struct NewsCardView: View {
    public let item: NewsItem

    public init(item: NewsItem) {
        self.item = item
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(.newsIcon)
                    .resizable()
                    .frame(width: 55, height: 55)

                VStack(alignment: .leading, spacing: 4) {
                    Text(self.item.author)
                        .font(.system(size: 18, weight: .semibold))

                    Text(self.item.date, format: self.dateStyle)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(.bottom, 10)

            Text(self.item.description)
                .lineLimit(3)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)

            self.categoriesView
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, y: 5)
        )
    }

    private var categoriesView: some View {
        HStack(spacing: 8) {
            ForEach(self.item.categories) { category in
                Text(category.name)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.green500)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.green500.opacity(0.2))
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var dateStyle: Date.FormatStyle {
        .dateTime.day(.twoDigits).month(.twoDigits).year(.extended())
    }
}
