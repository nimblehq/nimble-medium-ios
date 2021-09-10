//
//  FeedRow.swift
//  NimbleMedium
//
//  Created by Mark G on 01/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedRow: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            author
            VStack(alignment: .leading) {
                Text("title")
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text("description")
                    .foregroundColor(.gray)
            }
        }
    }

    var author: some View {
        HStack {
            // swiftlint:disable line_length
            if let url = try? "https://thumbs.dreamstime.com/b/vector-illustration-avatar-dummy-logo-collection-image-icon-stock-isolated-object-set-symbol-web-137160339.jpg".asURL() {
                // FIXME: It blocks UI
                WebImage(url: url)
                    .placeholder { defaultAvatar }
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
            } else {
                defaultAvatar
            }
            VStack(alignment: .leading) {
                Text("author name")
                Text("September 10, 2021")
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
