//
//  FeedCommentsView.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import SwiftUI

struct FeedCommentsView: View {

    var body: some View {
        Content(view: self)
    }
}

// MARK: - Content
private extension FeedCommentsView {

    struct Content: View {

        let view: FeedCommentsView

        var body: some View {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 12.0) {
                    // TODO: Update with real data in Integrate
                    ForEach(1...3, id: \.self) { _ in
                        FeedCommentRow()
                    }
                }
                .padding(.all, 16.0)
            }
            .navigationTitle(Localizable.feedCommentsTitle())
            .modifier(NavigationBarPrimaryStyle())
        }
    }
}
