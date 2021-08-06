//
//  HomeView.swift
//  NimbleMedium
//
//  Created by Mark G on 06/08/2021.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        #if PRODUCTION
        Text("Hello, production build")
            .padding()
        #elseif STAGING
        Text("Hello, staging build")
            .padding()
        #endif
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
