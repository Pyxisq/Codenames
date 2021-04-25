//
//  WebSocketService.swift
//  Codenames
//
//  Created by Dulat Bulat on 21.04.2021.
//

import Foundation

final class WebSocketService: ObservableObject, DataProvider {

  @Published var data: Data?

  private let session = URLSession.shared

  private var webSocketTask: URLSessionWebSocketTask!

  private func receiveData() {
    webSocketTask.receive { [unowned self] result in
      switch result {
      case .failure(let error):
        print("Error in receiving message: \(error)")
      case .success(let message):
        switch message {
        case .data(let data):
          DispatchQueue.main.async {
            self.data = data
          }
        default:
          debugPrint("Unknown message")
        }

        receiveData()
      }
    }
  }
}

extension WebSocketService {

  func connectToWebSocket(urlString: String) {
    guard let url = URL(string: urlString) else {
      return
    }
    webSocketTask = session.webSocketTask(with: url)
    webSocketTask.resume()
    receiveData()
  }

  func send(message: URLSessionWebSocketTask.Message) {
    webSocketTask.send(message) { error in
      if let error = error {
        print("WebSocket couldn’t send message because: \(error)")
      }
    }
  }
}
