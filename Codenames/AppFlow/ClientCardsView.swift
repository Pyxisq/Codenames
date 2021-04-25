//
//  ClientCardsView.swift
//  Codenames
//
//  Created by Dulat Bulat on 22.04.2021.
//

import SwiftUI

struct ClientCardsView: View {

  @EnvironmentObject private var websocketService: WebSocketService
  @EnvironmentObject private var cardService: CardService

  var body: some View {
    VStack {
      CardsView(isClient: true)
    }
    .onChange(of: websocketService.data) { data in
      guard let data = data else { return }
      let cards = try! JSONDecoder().decode([Card].self, from: data)
      cardService.cards = cards
    }
  }
}
