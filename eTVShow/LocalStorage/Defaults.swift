//
//  Defaults.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 24/12/22.
//

import UIKit

class Defaults
{
    private let defaults = UserDefaults.standard
  
    private let userKey = "user"
    private let sessionKey = "session"
  
    var user: String {
        get {
            return defaults.string(forKey: userKey) ?? ""
        }
        
        set {
            defaults.setValue(newValue, forKey: userKey)
        }
    }
    
    var session: String {
        get {
            return defaults.string(forKey: sessionKey) ?? ""
        }
        
        set {
            defaults.setValue(newValue, forKey: sessionKey)
        }
    }
  
    class var shared: Defaults {
        struct Static {
            static let instance = Defaults()
        }
      
        return Static.instance
    }
    
}
