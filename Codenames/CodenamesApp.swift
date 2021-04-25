//
//  CodenamesApp.swift
//  Codenames
//
//  Created by Dulat Bulat on 09.04.2021.
//

import SwiftUI

@main
struct CodenamesApp: App {

  private let sessionService = SessionService()
  private let socketService = WebSocketService()
  private let cardService = CardService()

  var body: some Scene {
    WindowGroup {
      MainPageView()
        .environmentObject(sessionService)
        .environmentObject(socketService)
        .environmentObject(cardService)
    }
  }
}
