//
//  HomeView.swift
//  NimbleMedium
//
//  Created by Mark G on 06/08/2021.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Text(R.string.localizable.homeTitle())
            .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
