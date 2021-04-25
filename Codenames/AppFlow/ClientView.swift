//
//  ClientView.swift
//  Codenames
//
//  Created by Dulat Bulat on 10.04.2021.
//

import SwiftUI

struct ClientView: View {

  @EnvironmentObject private var manager: WebSocketService

  @State private var ipAddress: String = ""

  @State private var receivedText: String = ""

  @State private var isPresented: Bool = false

  var body: some View {
    VStack {
      TextField("ip", text: $ipAddress)
      Button("Connect") {
        manager.connectToWebSocket(urlString: "ws://" + ipAddress + "/websocket")
        isPresented = true
      }
      Text(receivedText)
    }
    .fullScreenCover(isPresented: $isPresented) {
      ClientCardsView()
    }
  }
}

struct ClientViewPreview: PreviewProvider {

  static var previews: some View {
    ClientView()
  }
}
