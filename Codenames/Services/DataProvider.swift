//
//  DataProvider.swift
//  Codenames
//
//  Created by Dulat Bulat on 22.04.2021.
//

import Foundation
import SwiftUI

protocol DataProvider: ObservableObject {

  var data: Data? { get }
}

final class CardCodingService<T: DataProvider>: ObservableObject {

  private let dataProvider: T

  init(dataProvider: T) {
    self.dataProvider = dataProvider
  }
}
