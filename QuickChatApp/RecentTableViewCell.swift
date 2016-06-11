//
//  RecentTableViewCell.swift
//  QuickChatApp
//
//  Created by Bob McGinn on 5/23/16.
//  Copyright © 2016 REM Designs. All rights reserved.
//

import UIKit

class RecentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    let backendless = Backendless()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(recent: NSDictionary) {
        
        self.avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
        self.avatarImageView.layer.masksToBounds = true
        
        self.avatarImageView.image = UIImage(named: "avatarPlaceholder")
        
        let withUserID = (recent.objectForKey("withUseruserID") as? String)!
        
        //Get the backendless user and download avatar
        let whereClause = "objectId = '\(withUserID)'"
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
        
        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) -> Void in
            
            _ = users.data.first as! BackendlessUser
            
            //use withUser to get the avatar
            
        }) { (fault: Fault!) in
                print("Error, couldn't get user avatar: \(fault)")
        }
        
        self.nameLabel.text = recent["withUserUserName"] as? String
        self.lastMessageLabel.text = recent["lastMessage"] as? String
        self.counterLabel.text = ""
        
        if (recent["counter"] as? Int)! != 0 {
            self.counterLabel.text = "\(recent["counter"]!) New"
        }
        
        let date = dateFormatter().dateFromString((recent["date"] as? String)!)
        let seconds = NSDate().timeIntervalSinceDate(date!)
        
        dateLabel.text = self.TimeElapsed(seconds)
        
    }
    
    func TimeElapsed(seconds: NSTimeInterval) -> String {
        
        let elasped: String?
        
        if (seconds < 60) {
            elasped = "Just now"
        }
        else if (seconds < 60 * 60) {
            let minutes = Int(seconds / 60)
            
            var minText = "min"
            
            if minutes > 1 {
                minText = "mins"
            }
            
            elasped = "\(minutes) \(minText)"
        }
        else if (seconds < 24 * 60 * 60) {
            let hours = Int(seconds / (60 * 60))
            
            var hourText = "hour"
            
            if hours > 1 {
                hourText = "hours"
            }
            
            elasped = "\(hours) \(hourText)"
        }
        else {
            let days = Int(seconds / (24 * 60 * 60))
            
            var dayText = "day"
            
            if days > 1 {
                dayText = "days"
            }
            
            elasped = "\(days) \(dayText)"
        }
        
        return elasped!
        
    }

}
