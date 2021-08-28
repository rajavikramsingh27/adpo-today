//
//  NetworkManager.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 14.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation
import SystemConfiguration

struct NetworkManager {
    
    private let reachibility = SCNetworkReachabilityCreateWithName(nil, "www.google.com") //Checking to see if the app can reach google.com to check internet
       
    
    func internetIsReachable() -> Bool{
        
        var flags = SCNetworkReachabilityFlags()
        
        SCNetworkReachabilityGetFlags(self.reachibility!, &flags)
        
        if (isNetworkReach(with: flags)){
            
            print(flags)
            
            if flags.contains(.isWWAN){
                print("INTERNET VIA MOBILE")
            }else{ 
                print("INTERNET VIA WIFI")
            }
            
            return true
            
        }else if (!isNetworkReach(with: flags)){
            
            print("No INTERNET")
            
            print(flags)
            
            return false
            
        }
        
        return false
        
    }
    
    func isNetworkReach(with flags :SCNetworkReachabilityFlags) -> Bool{
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomaticly = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomaticly && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    
}
