//
//  WinnerView.swift
//  Codenames
//
//  Created by Dulat Bulat on 25.04.2021.
//

import SwiftUI

struct WinnerView<Content: View>: View {

  @Binding var blueWinner: Bool?

  let content: () -> Content
  let restartAction: () -> Void

  var body: some View {
    ZStack {
      content()
        .opacity(blueWinner == nil ? 1 : 0.5)
        .allowsHitTesting(blueWinner == nil)
      if blueWinner != nil {
        VStack {
          if blueWinner == true {
            Text("Blue win")
          } else {
            Text("Red win")
          }
          Button("Restart") {
            restartAction()
          }
        }
      }
    }
  }
}
