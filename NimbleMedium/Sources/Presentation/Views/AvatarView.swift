//
//  AvatarView.swift
//  NimbleMedium
//
//  Created by Mark G on 29/09/2021.
//

import SDWebImageSwiftUI
import SwiftUI

struct AvatarView: View {

    private let url: URL?
    private var size: CGFloat = 50.0
    private var isCircleShape = false

    var body: some View {
        if let url = url {
            // FIXME: It blocks UI
            WebImage(url: url)
                .placeholder { defaultAvatar }
                .resizable()
                .frame(width: size, height: size)
                .if(isCircleShape) {
                    $0.clipShape(Circle())
                }
        } else {
            defaultAvatar
        }
    }

    var defaultAvatar: some View {
        Image(R.image.defaultAvatar.name)
            .resizable()
            .frame(width: size, height: size)
            .if(isCircleShape) {
                $0.clipShape(Circle())
            }
    }

    init(url: URL? = nil) {
        self.url = url
    }

    func size(_ value: CGFloat) -> Self {
        var view = self
        view.size = value

        return view
    }

    func circle() -> Self {
        var view = self
        view.isCircleShape = true

        return view
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView()
    }
}
