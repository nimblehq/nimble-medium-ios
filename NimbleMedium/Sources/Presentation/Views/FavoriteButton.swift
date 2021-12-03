//
//  FavoriteButton.swift
//  NimbleMedium
//
//  Created by Mark G on 29/10/2021.
//

import SwiftUI

struct FavoriteButton: View {

    private let count: Int
    private let isSelected: Bool
    private let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            HStack {
                Text("\(count)")
                    .foregroundColor(isSelected ? .white : .green)
                Image(systemName: SystemImageName.heartFill.rawValue)
                    .foregroundColor(isSelected ? .white : .green)
            }
        })
        .frame(height: 30.0)
        .padding(.horizontal, 8.0)
        .background(isSelected ? Color.green : Color.clear)
        .cornerRadius(4.0)
        .overlay(
            RoundedRectangle(cornerRadius: 4.0)
                .stroke(Color.green, lineWidth: 1.0)
        )
    }

    init(
        count: Int,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.count = count
        self.isSelected = isSelected
        self.action = action
    }
}
