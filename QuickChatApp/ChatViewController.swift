//
//  ChatViewController.swift
//  QuickChatApp
//
//  Created by Bob McGinn on 5/31/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit

class ChatViewController: JSQMessagesViewController {

    let ref = Firebase(url: "https://quickchatappv2.firebaseio.com/Message")
    
    var messages: [JSQMessage] = []
    var objects: [NSDictionary] = []
    var loaded: [NSDictionary] = []
    
    var withUser: BackendlessUser?
    var recent: NSDictionary?
    
    var chatRoomID: String?
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.senderId = currentUser.objectId
        self.senderDisplayName = currentUser.name
        
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        //Load firebase messages
        
        self.inputToolbar?.contentView?.textView?.placeHolder = "New Message"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: JSQMessages datasource func
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let data = messages[indexPath.row]
        
        if data.senderId == currentUser.objectId {
            
            cell.textView?.textColor = UIColor.whiteColor()
        }
        else {
            
            cell.textView?.textColor = UIColor.blueColor()
            
        }
        
        return cell
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        let data = messages[indexPath.row]
        
        return data
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let data = messages[indexPath.row]
        
        if data.senderId == currentUser.objectId {
            
            return outgoingBubble
            
        }
        else {
            
            return incomingBubble
            
        }
        
    }
    
    //MARK: JSQMessages delegate functions
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        if text != "" {
            
            sendMessage(text, date: date, picture: nil, location: nil)
            
        }
        
    }

    override func didPressAccessoryButton(sender: UIButton!) {
        
        
        
    }
    
    //MARK: Send message
    
    func sendMessage(text: String?, date: NSDate, picture: UIImage?, location: String?) {
        
        var outGoingMessage = OutGoingMessage?()
        
        //if text message
        if let text = text {
            
            outGoingMessage = OutGoingMessage(message: text, senderId: currentUser.objectId!, senderName: currentUser.name!, date: date, status: "Delivered", type: "text")
            
        }
        
        //if pic message
        if let picture = picture {
            
        }
        
        //if location message
        if let loc = location {
            
        }
        
        //play message sent sound
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.finishSendingMessage()
        
        outGoingMessage!.sendMessage(chatRoomID!, item: outGoingMessage!.messageDictionary)
        
    }
    
}
