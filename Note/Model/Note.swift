//
//  Note.swift
//  Note
//
//  Created by Omid Shojaeian Zanjani on 19/07/24.
//

import Foundation
import SwiftData

@Model
class Note {
    var content:String
    var isFavorite:Bool = false
    var category: NoteCategory?
    
    init(content: String, category: NoteCategory? = nil) {
        self.content = content
        self.category = category
    }
}
