//
//  SideMenuDraggingAnimator.swift
//  NimbleMedium
//
//  Created by Mark G on 17/08/2021.
//

import SwiftUI

final class SideMenuDraggingAnimator {

    typealias OnUpdateCallback = (_ isOpen: Bool, _ progress: CGFloat) -> Void

    private var progress: CGFloat = 0.0
    private var isOpen = false

    func reset(isOpen: Bool) {
        self.isOpen = isOpen
        progress = isOpen ? 1.0 : 0.0
    }

    func onDraggingChanged(_ gesture: DragGesture.Value, _ width: CGFloat, onUpdate: OnUpdateCallback) {

        let translation = gesture.translation.width
        var progress = abs(translation) / width
        progress = progress > 1.0 ? 1.0 : progress

        switch isOpen {
        // Closing
        case true:
            progress = 1.0 - progress

            if translation > 0.0 {
                progress = 1.0
            }
        // Opening
        case false:
            if translation < 0.0 {
                progress = 0.0
            }
        }

        self.progress = progress
        onUpdate(isOpen, progress)
    }

    func onDraggingEnded(_ onUpdate: OnUpdateCallback) {
        // Update progress when dragging is stopped
        // in the middle of somewhere
        progress = progress < 0.5 ? 0.0 : 1.0
        isOpen = progress == 1.0
        onUpdate(isOpen, progress)
    }
}
