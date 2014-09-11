//
//  ChatUser.swift
//  GeneChat
//
//  Created by ChaCha on 9/11/14.
//  Copyright (c) 2014 ChaCha_gmo. All rights reserved.
//

import Foundation

class ChatUser : PFUser, PFSubclassing {
    override class  func load() {
        self.registerSubclass()
    }
    var phoneNumber : String? {
        get { return objectForKey("additional") as String? }
        set { setObject(newValue, forKey: "additional")}
    }
    

}
