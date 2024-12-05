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
            VStack(spacing: 24) {
                Text(self.store.guide.title)
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(self.store.guide.date, format: dateStyle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(self.store.guide.description)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                categoriesView
            }
            .padding(20)
        }
        .onFirstAppear {
            send(.onFirstAppear)
        }
        .onAppear {
            send(.onAppear)
        }
    }
    
    private var categoriesView: some View {
        HStack(spacing: 8) {
            ForEach(self.store.guide.categories) { category in
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
    
    private var dateStyle: Date.FormatStyle {
        .dateTime.day(.twoDigits).month(.twoDigits).year(.extended())
    }
}

#Preview {
    GuideDetailView(
        store: Store(
            initialState: GuideDetail.State(guide: .underwear)
        ) {
            GuideDetail()
        }
    )
}
