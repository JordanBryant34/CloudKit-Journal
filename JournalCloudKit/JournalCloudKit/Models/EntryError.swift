//
//  EntryError.swift
//  JournalCloudKit
//
//  Created by Jordan Bryant on 10/5/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

enum EntryError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
}
