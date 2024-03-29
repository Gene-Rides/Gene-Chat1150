//
//  FriendsViewController.swift
//  GeneChat
//
//  Created by ChaCha on 9/12/14.
//  Copyright (c) 2014 ChaCha_gmo. All rights reserved.
//

import UIKit


class FriendsViewController: PFQueryTableViewController, UISearchBarDelegate
    
{
    
    var searchText = ""
    var selectFriendMode = false
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.parseClassName = FriendShip.parseClassName()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = FriendShip.parseClassName()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset=UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        //Fix annoying UI bug
    }
    
    override func queryForTable() -> PFQuery! {
        var query : PFQuery!
        
        
        if searchText.isEmpty {
            
            query = FriendShip.query()
            query.whereKey("currentUser", equalTo: ChatUser.currentUser())
            query.includeKey("theFriend")
            
        } else {
            
            var userNameSearch = ChatUser.query()
            userNameSearch.whereKey("username", containsString: searchText)
            
            var emailSearch = ChatUser.query()
            emailSearch.whereKey("email", containsString: searchText)
            
            var additionalSearch = ChatUser.query()
            additionalSearch.whereKey("additional", containsString: searchText)
            
            query = PFQuery.orQueryWithSubqueries([userNameSearch, emailSearch, additionalSearch])
            
            
        }
        
        return query
    }
    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        
        var cellIdentifier = selectFriendMode ? "FriendCell" : "PFTableViewCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier("PFTableViewCell") as PFTableViewCell?
        
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "PFTableViewCell")
        }
        
        if object is FriendShip {
            var friends = object as FriendShip
            if cell is FriendCell {
                var friendCell = cell as? FriendCell
                friendCell?.setUpCell(friends)
            }else{
                cell?.textLabel?.text = friends.theFriend?.username
            }
            cell?.textLabel?.text = friends.theFriend?.username
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if selectFriendMode {return 0}
        
        return 44
    }
    
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if selectFriendMode {return nil}
        
        var headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as UITableViewCell
        
        return headerCell as UIView
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedObject = self.objectAtIndexPath(indexPath)
        if selectedObject is ChatUser {
            
            self.addFriend(selectedObject as ChatUser)
        }
    }
    
    func getTargetFriends() -> [ChatUser]
    {
        var targetFriends = [ChatUser]()
        let friendShips = self.objects as? [FriendShip]
        
        for friend in friendShips! {
            if friend.selected {
                targetFriends.append(friend.theFriend!)
            }
        }
        
        return targetFriends
    }
    
    func addFriend(friend:ChatUser) {
    var areFriends = FriendShip.query()
        areFriends.whereKey("currentUser", equalTo: ChatUser.currentUser())
        areFriends.whereKey("theFriend", equalTo: friend)
        areFriends.countObjectsInBackgroundWithBlock { (count,__) -> Void in
            if count > 0 {
                
                println("Not adding, already friends")
                
            }else {
                var bff = FriendShip()
                bff.currentUser = ChatUser.currentUser()
                bff.theFriend = friend
                bff.saveInBackground()
                println("adding \(bff.currentUser!.username) - > \(bff.theFriend!.username)")
            }
        }
    }
        
// Mark Search Bar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false

    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = nil
        searchText = ""
        self.loadObjects()
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchText = searchBar.text
        self.loadObjects()
    }
}
    
    
