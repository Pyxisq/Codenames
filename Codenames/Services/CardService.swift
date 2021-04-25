//
//  CardService.swift
//  Codenames
//
//  Created by Dulat Bulat on 22.04.2021.
//

import SwiftUI

final class CardService: ObservableObject {

  @Published var blueTurn = false
  @Published var cards: [Card] = []
  @Published var blueCardsCount = 7
  @Published var redCardsCount = 6

  @Published var blueWinner: Bool?

  private let words: [String]
  private var wordsCount: Int
  private var takenWordIndexes: Set<Int> = []

  init() {
    self.words = CardService.readJson()
    self.wordsCount = words.count
    generateCards()
  }

  private static func readJson() -> [String] {
    guard let path = Bundle.main.path(forResource: "words", ofType: "json") else {
      return []
    }

    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
      return try JSONDecoder().decode([String].self, from: data)
    } catch {
      return []
    }
  }

  private func count(type: CardType) -> Int {
    cards.filter { $0.type == type && !$0.isPresented }.count
  }

  private func generateCard(type: CardType) -> Card {
    var index = Int.random(in: 0..<wordsCount)
    while !takenWordIndexes.insert(index).inserted {
      index = .random(in: 0..<wordsCount)
    }

    return .init(type: type, title: words[index])
  }
}

extension CardService {

  func set(cards: [Card]) {
    self.cards = cards
  }

  func generateCards() {
    blueWinner = nil
    blueTurn = Bool.random()

    blueCardsCount = blueTurn ? 7 : 6
    redCardsCount = !blueTurn ? 7 : 6

    var cards = [generateCard(type: .black)]
    for _ in 0..<blueCardsCount {
      cards.append(generateCard(type: .blue))
    }
    for _ in 0..<redCardsCount {
      cards.append(generateCard(type: .red))
    }
    for _ in 0..<11 {
      cards.append(generateCard(type: .neutral))
    }
    for _ in 0..<Int.random(in: 5...20) {
      cards.shuffle()
    }
    self.cards = cards
  }

  func selectCard(index: Int) {
    if cards[index].isPresented { return }
    cards[index].isPresented = true
    let card = cards[index]

    switch card.type {
    case .blue:
      blueCardsCount = count(type: .blue)
    case .red:
      redCardsCount = count(type: .red)
    case .black:
      blueWinner = !blueTurn
    case .neutral:
      break
    }

    if blueCardsCount == 0 {
      blueWinner = true
    }
    if redCardsCount == 0 {
      blueWinner = false
    }

    if (blueTurn && card.type != .blue) || (!blueTurn && card.type != .red) {
      blueTurn.toggle()
    }
  }
}
