//
//  OutGoingMessage.swift
//  QuickChatApp
//
//  Created by Bob McGinn on 6/11/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import Foundation

class OutGoingMessage {
    
    private let fireBase = Firebase(url: "https://quickchatappv2.firebaseio.com/Message")
    
    let messageDictionary: NSMutableDictionary
    
    init (message: String, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        messageDictionary = NSMutableDictionary(objects: [message, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "senderId", "senderName", "date", "status", "type"])
        
    }
    
    init (message: String, latitude: NSNumber, longitude: NSNumber, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        messageDictionary = NSMutableDictionary(objects: [message, latitude, longitude, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "latitude", "longitude", "senderId", "senderName", "date", "status", "type"])
        
    }
    
    init (message: String, pictureData: NSData, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        let pic = pictureData.base64EncodedDataWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        messageDictionary = NSMutableDictionary(objects: [message, pic, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "pictureData", "senderId", "senderName", "date", "status", "type"])
        
    }
    
    func sendMessage (chatRoomID: String, item: NSMutableDictionary) {
        
        let reference = fireBase.childByAppendingPath(chatRoomID).childByAutoId()
        
        item["messageID"] = reference.key
        
        reference.setValue(item) { (error, ref) -> Void in
            
            if error != nil {
                
                print("Error, couldn't send message: \(error)")
                
            }
        }
        
        //send push notification to user 
        
        //update recents here
        UpdaterRecents(chatRoomID, lastMessage: (item["messageID"] as? String)!)
        
    }
    
}