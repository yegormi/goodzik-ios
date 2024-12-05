//
//  MessageBubble.swift
//  goodzik-ios
//
//  Created by Yehor Myropoltsev on 05.12.2024.
//
import SwiftUI

struct MessageBubble: View {
    let text: String
    let date: Date
    let isFromCurrentUser: Bool

    var body: some View {
        HStack {
            if isFromCurrentUser { Spacer() }

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(text)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .padding(.bottom, 16) // Extra bottom padding for the date
                .background(isFromCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isFromCurrentUser ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(alignment: .bottomTrailing) {
                    Text(date, style: .time)
                        .font(.caption2)
                        .foregroundColor(isFromCurrentUser ? .white.opacity(0.8) : .gray)
                        .padding(.trailing, 12)
                        .padding(.bottom, 8)
                }
            }

            if !isFromCurrentUser { Spacer() }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
   VStack(spacing: 16) {
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
}
