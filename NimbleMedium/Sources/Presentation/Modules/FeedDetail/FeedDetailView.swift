//
//  FeedDetailView.swift
//  NimbleMedium
//
//  Created by Mark G on 14/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedDetailView: View {

    var body: some View { Content(view: self) }
}

// MARK: - Content
private extension FeedDetailView {

    struct Content: View {

        let view: FeedDetailView

        var body: some View {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 16.0) {
                    Text("It's article title")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title)
                    author
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16.0)
                .padding(.horizontal, 8.0)
                .background(Color(R.color.dark.name))
                // swiftlint:disable line_length
                Text(
                    """
                    Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.

                    The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.
                    """
                )
                .padding(.horizontal, 8.0)

                AppMainButton(title: Localizable.feedsCommentsTitle()) {
                    // TODO: Go to Comments screen
                }
                .padding(.top, 16.0)
            }
            .navigationTitle(Localizable.feedDetailTitle())
            .modifier(NavigationBarPrimaryStyle())
        }

        var author: some View {
            AuthorView(
                articleUpdateAt: "May 02, 1991",
                authorName: "Mark",
                authorImage: nil
            )
            .authorNameColor(.white)
        }
    }
}
