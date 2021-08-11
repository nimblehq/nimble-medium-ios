//
//  HomeView.swift
//  NimbleMedium
//
//  Created by Mark G on 06/08/2021.
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        // TODO: Remove example code in UI task of this screen
        Screen {
            NavigationBar(title: "Home")
            Text("This is content")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
    }
}
