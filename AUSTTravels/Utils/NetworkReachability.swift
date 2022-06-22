//
//  NetworkReachability.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 19/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//
// Credit: DesignCode.io
//

import Foundation
import SystemConfiguration
import UIKit

class NetworkReachability: ObservableObject {
    
    @Published private(set) var reachable: Bool = false
    
    init() {
        checkConnection()
    }
    
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let connectionRequired = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutIntervention = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!connectionRequired || canConnectWithoutIntervention)
    }
    
    @discardableResult
    func checkConnection() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        reachable = isNetworkReachable(with: flags)
        return reachable
    }
}
