//
//  ReachabilityManager.swift
//  ExhibitSmart
//
//  Created by Asmaa Tarek on 01/06/2021.
//

import UIKit
import Network

 
class NetworkMonitor {
    static public let shared = NetworkMonitor()
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global()
    var netOn: Bool = true
    var connType: Constants.ConnectionType = .wifi
 
    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }
 
    func startMonitoring() {
        self.monitor.pathUpdateHandler = {[weak self] path in
            guard let self = self else { return }
            self.netOn = path.status == .satisfied
            self.connType = self.checkConnectionTypeForPath(path)
        }
    }
 
    func stopMonitoring() {
        self.monitor.cancel()
    }
 
    func checkConnectionTypeForPath(_ path: NWPath) -> Constants.ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        }
 
        return .unknown
    }
}
