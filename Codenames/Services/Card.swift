//
//  Card.swift
//  Codenames
//
//  Created by Dulat Bulat on 25.04.2021.
//

import Foundation
import SwiftUI

struct Card: Codable, Equatable {
  let type: CardType
  var isPresented: Bool = false
  let title: String
}

enum CardType: Int, Codable {
  case blue
  case red
  case black
  case neutral

  var color: Color {
    switch self {
    case .black:
      return .black
    case .blue:
      return .blue
    case .red:
      return .red
    case .neutral:
      return .green
    }
  }
}
