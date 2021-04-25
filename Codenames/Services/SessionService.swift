//
//  SessionService.swift
//  Codenames
//
//  Created by Dulat Bulat on 21.04.2021.
//

import Swifter
import SwiftUI

final class SessionService: ObservableObject, DataProvider {

  @Published var connections = 0

  @Published var isStarted = false

  @Published var data: Data?

  private var sessions: [WebSocketSession] = []

  private let server = HttpServer()
}

extension SessionService {

  func start() {
    do {
      server["/websocket"] = websocket(
        binary: { [unowned self] session, binary in
          print(binary)
          DispatchQueue.main.async {
            self.data = Data(binary)
          }
        },
        connected: { [unowned self] session in
          DispatchQueue.main.async {
            connections += 1
            if connections > 1 {
              session.socket.close()
              return
            }
            sessions.append(session)
            print("connected")
          }
        },
        disconnected: { [unowned self] session in
          print("disconnected")
          DispatchQueue.main.async {
            connections -= 1
          }
        }
      )
      try server.start(8080, forceIPv4: true, priority: .userInitiated)
      isStarted = true
    } catch {
      print("")
    }
  }

  func getAddress() -> String {
    if let address = server.listenAddressIPv4 ?? server.listenAddressIPv6 {
      return address
    }
    let port = try! server.port().description
    return Codenames.getAddress(for: .wifi)! + ":" + port
  }

  func send(data: Data) {
    sessions.forEach {
      $0.writeBinary([UInt8](data))
    }
  }
}

enum Network: String {
  case wifi = "en0"
  case cellular = "pdp_ip0"
  case ipv4 = "ipv4"
  case ipv6 = "ipv6"
}

func getAddress(for network: Network = .wifi) -> String? {
  var address: String?

  // Get list of all interfaces on the local machine:
  var ifaddr: UnsafeMutablePointer<ifaddrs>?
  guard getifaddrs(&ifaddr) == 0 else { return nil }
  guard let firstAddr = ifaddr else { return nil }

  // For each interface ...
  for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
    let interface = ifptr.pointee

    // Check for IPv4 or IPv6 interface:
    let addrFamily = interface.ifa_addr.pointee.sa_family
    if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

      // Check interface name:
      let name = String(cString: interface.ifa_name)
      if name == network.rawValue {

        // Convert interface address to a human readable string:
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                    &hostname, socklen_t(hostname.count),
                    nil, socklen_t(0), NI_NUMERICHOST)
        address = String(cString: hostname)
      }
    }
  }
  freeifaddrs(ifaddr)

  return address
}
