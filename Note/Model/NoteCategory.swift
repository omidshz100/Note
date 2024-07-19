//
//  NoteCategory.swift
//  Note
//
//  Created by Omid Shojaeian Zanjani on 19/07/24.
//

import Foundation
import SwiftData

@Model
class NoteCategory {
    var categoryTitle:String
    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \Note.category)
    var notes:[Note]?
    
    init(categoryTitle: String) {
        self.categoryTitle = categoryTitle
    }
}
