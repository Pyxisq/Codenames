//
//  HostCardsView.swift
//  Codenames
//
//  Created by Dulat Bulat on 22.04.2021.
//

import SwiftUI

struct HostCardsView: View {

  @EnvironmentObject private var sessionService: SessionService
  @EnvironmentObject private var cardService: CardService

  var body: some View {
    WinnerView(blueWinner: $cardService.blueWinner) {
      VStack {
        HStack {
          Text((cardService.blueTurn ? "Blue" : "Red") + " Turn")
            .foregroundColor(cardService.blueTurn ? .blue : .red)
          Text(cardService.blueCardsCount.description)
            .foregroundColor(.blue)
          Text(cardService.redCardsCount.description)
            .foregroundColor(.red)
          Text(sessionService.connections.description)
          Button("Restart") {
            restart()
          }
        }
        CardsView(isClient: false)
      }
    } restartAction: {
      restart()
    }
    .onChange(of: cardService.cards) { cards in
      let data = try! JSONEncoder().encode(cards)
      sessionService.send(data: data)
    }
    .onChange(of: sessionService.data) { data in
      guard let data = data else { return }
      let cards = try! JSONDecoder().decode([Card].self, from: data)
      cardService.cards = cards
      sessionService.send(data: data)
    }
  }

  private func restart() {
    cardService.generateCards()
  }
}
