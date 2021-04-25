//
//  HostView.swift
//  Codenames
//
//  Created by Dulat Bulat on 10.04.2021.
//

import SwiftUI
import Swifter

struct HostView: View {

  @EnvironmentObject private var sessionService: SessionService

  @State private var isPresented = false

  var body: some View {
    if sessionService.isStarted {
      VStack {
        Text(sessionService.connections.description)
        Text(sessionService.getAddress())
          .onTapGesture {
            UIPasteboard.general.string = sessionService.getAddress()
          }
        Button("Start") {
          isPresented = true
        }
        .fullScreenCover(isPresented: $isPresented) {
          HostCardsView()
        }
      }
    } else {
      Button("Create") {
        sessionService.start()
      }
    }
  }
}

struct HostViewProvider: PreviewProvider {

  static var previews: some View {
    HostView()
  }
}
