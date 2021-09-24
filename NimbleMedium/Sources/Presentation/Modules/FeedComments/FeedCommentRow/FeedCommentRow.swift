//
//  FeedCommentRow.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedCommentRow: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            // TODO: Update with real data in Integrate
            Text("Cypress comment")
                .padding(.all, 16.0)
            Divider()
                .frame(maxWidth: .infinity)
                .background(Color(R.color.semiLightGray.name))
            author
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(
                    Color(R.color.semiLightGray.name),
                    lineWidth: 1.0
                )
        )
    }

    var author: some View {
        HStack {
            // TODO: Update with real data in Integrate
            if let url = try? "https://cdn3.iconfinder.com/data/icons/avatars-15/64/_Ninja-2-512.png".asURL() {
                // FIXME: It blocks UI
                WebImage(url: url)
                    .placeholder { defaultAvatar }
                    .resizable()
                    .frame(width: 25.0, height: 25.0)
            } else {
                defaultAvatar
            }
            Text("cypresscypresscypresscypresscypresscypresscypresscypresscypresscypresscypresscypress")
                .foregroundColor(.green)
            Text("August 12, 2021")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 16.0)
        .background(Color(R.color.lightGray.name))
    }

    var defaultAvatar: some View {
        Image(R.image.defaultAvatar.name)
            .resizable()
            .frame(width: 25.0, height: 25.0)
    }
}
