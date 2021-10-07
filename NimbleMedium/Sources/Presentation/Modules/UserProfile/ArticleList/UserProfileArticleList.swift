//
//  UserProfileArticleListView.swift
//  NimbleMedium
//
//  Created by Mark G on 29/09/2021.
//

import SwiftUI

struct UserProfileArticleList: View {

    private let viewModels: [ArticleRowViewModelProtocol]

    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModels, id: \.output.id) { viewModel in
                    ArticleRow(viewModel: viewModel)
                        .padding(.bottom, 16.0)
                }
            }
            .padding(.all, 16.0)
        }
    }

    init(viewModels: [ArticleRowViewModelProtocol]) {
        self.viewModels = viewModels
    }
}
