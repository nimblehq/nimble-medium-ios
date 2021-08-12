//
//  HomeView.swift
//  NimbleMedium
//
//  Created by Mark G on 06/08/2021.
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        // TODO: Remove example code
        NavigationView {
            Text("This is home")
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarColor(backgroundColor: .green)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
    }
}
