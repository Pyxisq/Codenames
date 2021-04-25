//
//  MainPageView.swift
//  Codenames
//
//  Created by Dulat Bulat on 09.04.2021.
//

import SwiftUI

struct MainPageView: View {

  @State private var isHost = false

  @State private var isClient = false

  var body: some View {
    VStack() {
      Text("Codenames")
      Spacer()
      Button("Host") {
        isHost = true
      }
      .sheet(isPresented: $isHost) {
        HostView()
      }
      .padding()
      Button("Connect") {
        isClient = true
      }
      .sheet(isPresented: $isClient) {
        ClientView()
      }
      .padding()
      Button("About") {

      }
      .padding()
      Spacer()
    }
  }
}

struct MainPageViewPreview: PreviewProvider {

  static var previews: some View {
    MainPageView()
  }
}
