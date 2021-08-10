//
//  HomeView.swift
//  NimbleMedium
//
//  Created by Mark G on 06/08/2021.
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        // TODO: Update the title and its content in Home integrate task
        Screen(title: Localizable.homeTitle()) {
            Text("This is home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
    }
}
