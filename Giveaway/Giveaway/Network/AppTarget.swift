//
//  AppTarget.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

struct AppTarget: Target {
    var appEnvironment: AppEnvironment = .release
    
    var kAppHost: String {
        switch appEnvironment {
        default:
            return "www.gamerpower.com"
        }
    }
    
    var kMainAPIPath: String? {
        return "api"
    }
    
    var kAppScheme: String {
        switch appEnvironment {
            default: "https"
        }
    }
    
    
}
