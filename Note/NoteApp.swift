//
//  NoteApp.swift
//  Note
//
//  Created by Omid Shojaeian Zanjani on 19/07/24.
//

import SwiftUI
import SwiftData

@main
struct NoteApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            // setting min frame
                .frame(minWidth: 320, minHeight: 400)
        }
        .windowResizability(.contentSize)
        // Setting the Data model to the app
        .modelContainer(for: [Note.self, NoteCategory.self])
    }
}
