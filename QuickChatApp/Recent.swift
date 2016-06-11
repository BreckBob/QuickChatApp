//
//  Recent.swift
//  QuickChatApp
//
//  Created by Bob McGinn on 5/25/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import Foundation

let fireBase = Firebase(url: "https://quickchatappv2.firebaseio.com/")
let backendless = Backendless.sharedInstance()
let currentUser = backendless.userService.currentUser

//MARK: Create chatroom

func startChat(user1: BackendlessUser, user2: BackendlessUser) -> String {
    
    //user1 is current user
    let userId1: String = user1.objectId
    let userId2: String = user2.objectId
    
    var chatRoomID: String = ""
    
    let value = userId1.compare(userId2).rawValue
    
    if value < 0 {
        
        chatRoomID = userId1.stringByAppendingString(userId2)
        
    } else {
        
        chatRoomID = userId2.stringByAppendingString(userId1)
        
    }
    
    let members = [userId1, userId2]
    
    //Create recent item
    CreateRecent(userId1, chatRoomID: chatRoomID, members: members, withUserUsername: user2.name!, withUseruserID: userId2)
    CreateRecent(userId2, chatRoomID: chatRoomID, members: members, withUserUsername: user1.name!, withUseruserID: userId1)
    
    return chatRoomID
    
}

//MARK: Create recent item

func CreateRecent(userId: String, chatRoomID: String, members: [String], withUserUsername: String, withUseruserID: String) {
    
    fireBase.childByAppendingPath("Recent").queryOrderedByChild("chatRoomID").queryEqualToValue(chatRoomID).observeSingleEventOfType(.Value, withBlock:{
        snapshot in
        
        var createRecent = true
        
        //check if we have a result
        if snapshot.exists() {
            
            for recent in snapshot.value.allValues {
                
                //If we already have recent with passed userId, we don't create a new one
                if recent["userId"] as! String == userId {
                    
                    createRecent = false
                    
                }
            }
        }
        
        if createRecent {
            
            CreateRecentItem(userId, chatRoomID: chatRoomID, members: members, withUserUserName: withUserUsername, withUseruserID: withUseruserID)
            
        }
    })
}

func CreateRecentItem(userId: String, chatRoomID: String, members: [String], withUserUserName: String, withUseruserID: String) {
    
    let ref = fireBase.childByAppendingPath("Recent").childByAutoId()
    
    let recentId = ref.key
    let date = dateFormatter().stringFromDate(NSDate())
    
    let recent = ["recentId" : recentId, "userId" : userId, "chatRoomID" : chatRoomID, "members" : members, "withUserUserName" : withUserUserName, "lastMessage" : "", "counter" : 0, "date" : date, "withUseruserID" : withUseruserID]
    
    //save to firebase
    ref.setValue(recent) { (error, ref) -> Void in
        
        if error != nil {
            print("Error creating recent: \(error)")
        }
        
    }
}

//MARK: Update recent

func UpdaterRecents(chatRoomID: String, lastMessage: String) {
    
    fireBase.childByAppendingPath("Recent").queryOrderedByChild("chatRoomID").queryEqualToValue(chatRoomID).observeSingleEventOfType(.Value, withBlock:{
        snapshot in
      
        if snapshot.exists() {
            
            for recent in snapshot.value.allValues {
                
                //Update recent
                UpdateRecentItem(recent as! NSDictionary, lastMessage: lastMessage)
                
            }
            
        }
        
    })
    
}

func UpdateRecentItem (recent: NSDictionary, lastMessage: String) {
    
    let date = dateFormatter().stringFromDate(NSDate())
    
    var counter = recent["counter"] as! Int
    
    if recent["userId"] as? String != currentUser.objectId {
        counter += 1
    }
    
    let values = ["lastMessage" : lastMessage, "counter" : counter, "date" : date]
    
    fireBase.childByAppendingPath("Recent").childByAppendingPath(recent["recentId"] as? String).updateChildValues(values as [NSObject : AnyObject], withCompletionBlock: {(error, ref) -> Void in
        
        if error != nil {
            
            print("Couldn't update recent item")
            
        }
        
    })
    
}

//MARK: Restart recent chat
func RestartRecentChat(recent: NSDictionary) {
    
    for userId in recent["members"] as! [String] {
        
        if userId != currentUser.objectId {
            
            CreateRecent(userId, chatRoomID: (recent["chatRoomID"] as? String)!, members: (recent["members"] as? [String])!, withUserUsername: currentUser.name, withUseruserID: currentUser.objectId)
            
        }
    }
}


//MARK: Delete recent functions
func deleteRecentItem(recent: NSDictionary) {
    
    
    fireBase.childByAppendingPath("Recent").childByAppendingPath(recent["recentId"] as? String).removeValueWithCompletionBlock { (error, ref) in
        
        if error != nil {
        
            print("Error deleting recent item: \(error)")
        }
    }
}


//MARK: Helper functions

private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> NSDateFormatter {
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
    
}