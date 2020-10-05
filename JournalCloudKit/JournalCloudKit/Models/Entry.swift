//
//  Entry.swift
//  JournalCloudKit
//
//  Created by Jordan Bryant on 10/5/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation
import CloudKit

struct EntryConstants {
    static let titleKey = "title"
    static let bodyKey = "body"
    static let timestampKey = "timestamp"
    static let recordTypeKey = "Entry"
}

class Entry {
    var title: String
    var body: String
    var timestamp: Date
    var ckRecordId: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), ckRecordId: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordId = ckRecordId
    }
}

extension CKRecord {
    
    convenience init(entry: Entry){
        self.init(recordType: EntryConstants.recordTypeKey, recordID: entry.ckRecordId)
        self.setValue(entry.title, forKey: EntryConstants.titleKey)
        self.setValue(entry.body, forKey: EntryConstants.bodyKey)
        self.setValue(entry.timestamp, forKey: EntryConstants.timestampKey)
    }
    
}

extension Entry {
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryConstants.titleKey] as? String else { return nil }
        guard let body = ckRecord[EntryConstants.bodyKey] as? String else { return nil }
        guard let timeStamp = ckRecord[EntryConstants.timestampKey] as? Date else { return nil }
        
        self.init(title: title, body: body, timestamp: timeStamp)
    }

}
