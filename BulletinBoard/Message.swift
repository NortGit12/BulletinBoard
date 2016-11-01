//
//  Message.swift
//  BulletinBoard
//
//  Created by Jeff Norton on 11/1/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import Foundation
import CloudKit

struct Message {
    
    let text: String
    let timestamp: Date
}

// Extension for CloudKit

extension Message {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    static let recordType = "Message"
    static let textKey = "text"
    static let dateKey = "date"
    
    var cloudKitRecord: CKRecord {
        
        let record = CKRecord(recordType: Message.recordType)
        record.setValue(self.text, forKey: Message.textKey)
        record[Message.dateKey] = timestamp as NSDate
        
        return record
    }
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    init?(cloudKitRecord: CKRecord) {
        
        guard let text = cloudKitRecord[Message.textKey] as? String
            , let date = cloudKitRecord[Message.dateKey] as? Date
            , cloudKitRecord.recordType == Message.recordType else {
                
                NSLog("Error getting instance data from CKRecord.")
                return nil
        }
        
        self.text = text
        self.timestamp = date
    }
}














