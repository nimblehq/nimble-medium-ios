//
//  FeedsView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI
import Refresh

// swiftlint:disable file_types_order
struct FeedsView: View {

    @ObservedViewModel private var viewModel: FeedsViewModelProtocol
    let articles: [Article] = [Int](0...10).map { _ in
        DummyArticle()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(articles, id: \.title) { article in
                        FeedRow(article: article)
                            .padding(.bottom, 16.0)
                    }

                    // TODO: Integrate load more
                    RefreshFooter(
                        refreshing: Binding.constant(true),
                        action: {
                            print("load more")
                        },
                        label: {
                            ProgressView()
                        }
                    )
                }
                .padding(.all, 16.0)

            }
            .enableRefresh()
            .navigationTitle(Localizable.feedTitle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(backgroundColor: .green)
            .toolbar { navigationBarLeadingContent }
        }
    }

    var navigationBarLeadingContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(
                action: {
                    viewModel.input.toggleSideMenu()
                },
                label: {
                    Image(R.image.menuIcon.name)
                }
            )
        }
    }

    init(viewModel: FeedsViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// TODO: Remove dummy model in Integrate
struct DummyProfile: Profile {

    var username: String = DummyArticle.random()
    var bio: String?  = DummyArticle.random()
    // swiftlint:disable line_length
    var image: String?  = "https://thumbs.dreamstime.com/b/vector-illustration-avatar-dummy-logo-collection-image-icon-stock-isolated-object-set-symbol-web-137160339.jpg"
    var following: Bool = Bool.random()
}

struct DummyArticle: Article {

    let slug: String = Self.random()
    let title: String = Self.random(Int.random(in: 100...300))
    let description: String = Self.random(Int.random(in: 100...500))
    let body: String = Self.random(100)
    let tagList: [String] = [Int](0...Int.random(in: 0...10)).map { _ in Self.random(10) }
    let createdAt: Date = Date()
    let updatedAt: Date = Date()
    let favorited: Bool = Bool.random()
    let favoritesCount: Int = Int.random(in: 0...100)
    let author: Profile = DummyProfile()

    static func random(_ length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            // swiftlint:disable legacy_random
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}

#if DEBUG
struct FeedsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedsView(viewModel: FeedsViewModel())
    }
}
#endif
