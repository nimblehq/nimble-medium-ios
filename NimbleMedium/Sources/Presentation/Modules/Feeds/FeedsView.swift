//
//  FeedsView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI

struct FeedsView: View {
    
    var body: some View {
        NavigationView {
            Text("This is feed content") // TODO: Update it in Integrate task
                .navigationTitle(Localizable.feedTitle())
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarColor(backgroundColor: .green)
                .toolbar { navigationBarLeadingContent }
        }
    }

    var navigationBarLeadingContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(
                action: {},
                label: {
                    Image(R.image.menuIcon.name)
                }
            )
        }
    }
}

struct FeedsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedsView()
    }
}
