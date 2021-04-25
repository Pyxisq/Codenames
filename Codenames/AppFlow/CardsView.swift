//
//  CardsView.swift
//  Codenames
//
//  Created by Dulat Bulat on 09.04.2021.
//

import SwiftUI

struct CardsView: View {

  @EnvironmentObject var cardService: CardService

  var isClient: Bool

  var body: some View {
    VStack {
      ForEach(0..<5) { x in
        HStack {
          ForEach(0..<5) { y in
            generate(position: x * 5 + y)
          }
        }
      }
    }
    .padding()
  }

  private func generate(position: Int) -> some View {
    CardView(card: $cardService.cards[position], isClient: isClient)
      .onTapGesture {
        if !isClient {
          cardService.selectCard(index: position)
        }
      }
  }
}
