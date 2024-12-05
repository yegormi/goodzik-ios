import SwiftUI

struct MenuButton: View {
    let title: String
    let image: ImageResource
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Image(self.image)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(self.tint)

                Text(self.title)
                    .tint(self.tint)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
