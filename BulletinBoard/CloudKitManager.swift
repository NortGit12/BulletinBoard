//
//  CloudKitManager.swift
//  BulletinBoard
//
//  Created by Jeff Norton on 11/1/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    let database = CKContainer.default().publicCloudDatabase
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    func fetchRecords(ofType type: String, sortDescriptors: [NSSortDescriptor]? = nil
        , completion: @escaping ([CKRecord]?, Error?) -> Void) {
        
        let query = CKQuery(recordType: type, predicate: NSPredicate(value: true))
        query.sortDescriptors = sortDescriptors
        
        database.perform(query, inZoneWith: nil, completionHandler: completion)
    }
    
    func save(record: CKRecord, completion: @escaping ((Error?) -> Void) = { _ in }) {

        database.save(record) { (record, error) in
            
            completion(error)
        }
    }
}
