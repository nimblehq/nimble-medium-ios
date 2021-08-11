//
//  FeedView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI

struct FeedView: View {
    
    var body: some View {
        NavigationView {
            Text("This is feed content") // TODO: Update it in Integrate task
                .navigationTitle(Localizable.feedTitle())
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarColor(backgroundColor: .green)
                .toolbar { navMenuToolbarItem }
        }
    }

    var navMenuToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(
                action: {},
                label: {
                    Image(R.image.navMenuBtn.name)
                }
            )
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
