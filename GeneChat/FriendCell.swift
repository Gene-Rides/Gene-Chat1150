//
//  FriendCell.swift
//  GeneChat
//
//  Created by ChaCha on 9/12/14.
//  Copyright (c) 2014 ChaCha_gmo. All rights reserved.
//

import UIKit

class FriendCell: PFTableViewCell {
    
    @IBOutlet weak var checkBox: UIImageView!
    var theFriendShip : FriendShip?
    
    func setUpCell(friends:FriendShip)  {
        theFriendShip = friends
        self.textLabel?.text = friends.theFriend?.username
    }
    
    @IBAction func checkBoxTapped(sender: AnyObject) {
        
        theFriendShip!.selected = !theFriendShip!.selected
        var imageName = theFriendShip!.selected ? "checkbox+checked" :"checkbox_unchecked"
        checkBox.image = UIImage(named: imageName)
    
    }
}
