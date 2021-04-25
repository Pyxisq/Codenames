//
//  CardView.swift
//  Codenames
//
//  Created by Dulat Bulat on 25.04.2021.
//

import SwiftUI

struct CardView: View {

  @Binding var card: Card
  var isClient: Bool

  var body: some View {
    ZStack {
      if isClient || card.isPresented {
        card.type.color
      } else {
        Color.white
      }
      Text(card.title)
        .padding()
        .foregroundColor(isClient || card.isPresented ? .white : .black)
    }
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .stroke(Color.gray, lineWidth: 4)
    )
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}
