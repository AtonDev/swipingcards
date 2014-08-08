//
//  TokenModel.swift
//  swipingCards
//
//  Created by APG on 07/08/14.
//  Copyright (c) 2014 APG. All rights reserved.
//

import Foundation


//
//  TokenModel.swift
//  alts
//  model responsible for getting and storing the token ID
//
//  Created by APG on 05/08/14.
//  Copyright (c) 2014 APG. All rights reserved.
//

import Foundation

class TokenModel {
    var userDefaults = NSUserDefaults()
    let getTokenURL = NSURL(string:"http://0.0.0.0:3000/new_token")
    var token = ""
    
    func getToken() {
        if userDefaults.objectForKey("token") == nil {
            let task = NSURLSession.sharedSession().dataTaskWithURL(getTokenURL){(data, response, error) in
                if data.length != 0 {
                    var err: NSError?
                    let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                    self.token = jsonDict["token"] as String
                    self.saveToken()
                }
            }
            task.resume()
        } else {
            self.token = userDefaults.objectForKey("token") as String
            println("old \(self.token)")
        }
    }
    
    func saveToken() {
        if token == "" {
            self.getToken()
        } else {
            userDefaults.setObject(self.token, forKey: token)
        }
    }
    
    
    
}
