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
    private let accountKey = "account"
    private let avatarKey = "avatar"
  
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
    
    var account: Int {
        get {
            return defaults.integer(forKey: accountKey)
        }
        
        set {
            defaults.setValue(newValue, forKey: accountKey)
        }
    }
    
    var avatar: String {
        get {
            return defaults.string(forKey: avatarKey) ?? ""
        }
        
        set {
            defaults.setValue(newValue, forKey: avatarKey)
        }
    }
  
    class var shared: Defaults {
        struct Static {
            static let instance = Defaults()
        }
      
        return Static.instance
    }
    
}
