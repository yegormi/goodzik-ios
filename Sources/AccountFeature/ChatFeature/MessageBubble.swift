import Styleguide
import SwiftUI

struct MessageBubble: View {
    let text: String
    let date: Date
    let isFromCurrentUser: Bool

    var body: some View {
        HStack {
            if self.isFromCurrentUser { Spacer() }

            VStack(alignment: .trailing, spacing: 2) {
                Text(self.text)

                Text(self.date, style: .time)
                    .font(.caption2)
                    .foregroundColor(self.isFromCurrentUser ? Color(UIColor.systemGray2) : .gray)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(self.isFromCurrentUser ? Color.messageOutgoing : Color.messageIncoming)
            .foregroundColor(self.isFromCurrentUser ? .white : Color.textPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            if !self.isFromCurrentUser { Spacer() }
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        MessageBubble(
            text: "Hey, how are you?",
            date: Date(),
            isFromCurrentUser: false
        )

        MessageBubble(
            text: "I'm doing great! Thanks for asking 😊",
            date: Date(),
            isFromCurrentUser: true
        )

        MessageBubble(
            text: "This is a really long message that will wrap to multiple lines to demonstrate how the date placement works with longer content333333",
            date: Date(),
            isFromCurrentUser: true
        )
    }
    .padding(12)
}
