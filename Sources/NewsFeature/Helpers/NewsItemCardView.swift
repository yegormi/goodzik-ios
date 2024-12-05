//
//  NewsItemCardView.swift
//  goodzik-ios
//
//  Created by Yehor Myropoltsev on 05.12.2024.
//

import SwiftUI
import SwiftUIHelpers
import SharedModels

public struct NewsItemCardView: View {
    public let item: NewsItem
    
    public init(item: NewsItem) {
        self.item = item
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                if let imageURL = item.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(.newsIcon)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text(item.date.formatted(date: .numeric, time: .omitted))
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            Text(item.description)
                .lineLimit(3)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
            categoriesView
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: .black.opacity(0.1), radius: 8, y: 5)
        )
    }
    
    private var categoriesView: some View {
        HStack(spacing: 8) {
            ForEach(item.categories) { category in
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
}
