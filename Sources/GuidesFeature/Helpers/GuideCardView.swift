import SharedModels
import SwiftUI

public struct GuideCardView: View {
    public let guide: Guide

    public init(guide: Guide) {
        self.guide = guide
    }

    public var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 0) {
                Text(self.guide.title)
                    .font(.system(size: 18, weight: .semibold))

                Spacer()

                Text(self.guide.date, format: self.dateStyle)
                    .font(.system(size: 12, weight: .semibold))
            }

            Text(self.guide.description)
                .lineLimit(3)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 8) {
                ForEach(self.guide.categories, id: \.id) { category in
                    Text(category.name)
                        .font(.system(size: 11))
                        .foregroundStyle(Color.green500)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.green500.opacity(0.2))
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 8, y: 5)
        )
    }

    var dateStyle: Date.FormatStyle {
        .dateTime.day(.twoDigits).month(.twoDigits).year(.extended())
    }
}
