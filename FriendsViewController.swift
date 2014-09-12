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
        
        //Fix annoying UI bug
    }
    
    override func queryForTable() -> PFQuery! {
        var query : PFQuery!
        
        query = FriendShip.query()
        query.whereKey("currentUser", equalTo: ChatUser.currentUser())
        query.includeKey("theFriend")
        
        return query
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("PFTableViewCell") as PFTableViewCell?
        
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "PFTableViewCell")
        }
        
        if object is FriendShip {
            var friends = object as FriendShip
            
            cell?.textLabel?.text = friends.theFriend?.username
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as UITableViewCell
        
        return headerCell as UIView
    }
// Mark Search Bar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false

    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
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
    
    
