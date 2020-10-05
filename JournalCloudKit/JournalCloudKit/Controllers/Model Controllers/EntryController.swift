//
//  EntryController.swift
//  JournalCloudKit
//
//  Created by Jordan Bryant on 10/5/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    static let shared = EntryController()
    
    var entries: [Entry] = []
    
    let  privateDB = CKContainer.default().privateCloudDatabase
    
    //MARK: - CRUD Functions
    
    func createEntry(with title: String, body: String, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        let entry = Entry(title: title, body: body)
        
        save(entry: entry, completion: completion)
    }
    
    func save(entry: Entry, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        let record = CKRecord(entry: entry)
        
        privateDB.save(record) { (record, error) in
            if let error = error {
                print("Error saving Entry CKRecord in EntryController: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.ckError(error)))
                }
                return
            }
            
            guard let record = record, let entryFromRecord = Entry(ckRecord: record) else {
                print("Could not unwrap saved record in EntryController.")
                DispatchQueue.main.async {
                    completion(.failure(.couldNotUnwrap))
                }
                return
            }
            
            self.entries.insert(entryFromRecord, at: 0)
            
            DispatchQueue.main.async {
                completion(.success(entryFromRecord))
            }
        }
    }
    
    func fetchEntries(completion: @escaping (_ result: Result<[Entry]?,EntryError>) -> Void) {
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: EntryConstants.recordTypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("CKError retrieving entries: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.ckError(error)))
                }
            }
            
            guard let records = records else { return completion(.failure(.couldNotUnwrap)) }
            
            let entries = records.compactMap({ Entry(ckRecord: $0) })
            self.entries = entries
            
            DispatchQueue.main.async {
                completion(.success(entries))
            }
        }
    }
    
}
