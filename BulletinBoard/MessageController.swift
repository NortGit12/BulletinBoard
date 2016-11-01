//
//  MessageController.swift
//  BulletinBoard
//
//  Created by Jeff Norton on 11/1/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import Foundation

protocol MessagesDelegate {
    
    func messagesUpdated()
}

class MessageController {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    var cloudKitManager = CloudKitManager()
    var delegate: MessagesDelegate?
    var messages = [Message]() {
        
        didSet {
            
            refresh()
            delegate?.messagesUpdated()
        }
    }
    static let shared = MessageController()
    
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    init() {
        
        refresh()
    }
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    func refresh(completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        // Create a sort descriptor
        
        let sortDescriptor = NSSortDescriptor(key: Message.dateKey, ascending: false)
        
        // Fetch all messages from CloudKit
        
        cloudKitManager.fetchRecords(ofType: Message.recordType, sortDescriptors: [sortDescriptor]) { (records, error) in
            
            defer { completion(error) }
            
            // Handle any errors
            
            if let error = error {
                
                NSLog("Error fetching message: \(error.localizedDescription)")
                return
            }
            
            // Do things when it succeeded
            
            guard let records = records else {
                
                NSLog("Error unwrapping the records")
                return
            }
            
            DispatchQueue.main.async {
            
                self.messages = records.flatMap({ Message(cloudKitRecord: $0) })
            }
        }
    }
    
    func post(message: Message, completion: @escaping ((Error?) -> Void) = { _ in }) {

        // Get the message's cloudKitRecord property
        
        let record = message.cloudKitRecord
        
        // Save the record to CloudKit
        
        cloudKitManager.save(record: record) { (error) in
            
            // Handle any errors
            
            if let error = error {
                
                NSLog("Error saving \(message) to CloudKit: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            // Do things when it succeeded
            
            self.messages.append(message)
            
            DispatchQueue.main.async {
                
                completion(error)
            }
        }
    }
}















