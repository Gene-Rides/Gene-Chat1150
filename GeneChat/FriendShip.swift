//
//  FriendShip.swift
//  GeneChat
//
//  Created by ChaCha on 9/12/14.
//  Copyright (c) 2014 ChaCha_gmo. All rights reserved.
//

import Foundation

class FriendShip: PFObject, PFSubclassing {
    
    override class func load()
    {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "FriendShip"
    }
    
    var currentUser : ChatUser? {
        get { return objectForKey("currentUser") as? ChatUser}
        set { setObject(newValue, forKey: "currentUser")}
    }
        var theFriend: ChatUser? {
        get { return objectForKey("theFriend") as? ChatUser}
            set { setObject(newValue, forKey: "theFriend")}
    }
    
    var selected = false
    
}
