//
//  FeedRow.swift
//  NimbleMedium
//
//  Created by Mark G on 01/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedRow: View {
    
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            author
            VStack(alignment: .leading) {
                Text(article.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(article.description)
                    .foregroundColor(.gray)
            }
        }
    }

    var author: some View {
        HStack {
            if let url = try? article.author.image?.asURL() {
                // FIXME: It blocks UI
                WebImage(url: url)
                    .placeholder { defaultAvatar }
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
            } else {
                defaultAvatar
            }
            VStack(alignment: .leading) {
                Text(article.author.username)
                Text(article.formattedUpdatedAt)
                    .foregroundColor(.gray)
            }
        }
    }

    var defaultAvatar: some View {
        Image(R.image.defaultAvatar.name)
            .resizable()
            .frame(width: 50.0, height: 50.0)
    }
}
