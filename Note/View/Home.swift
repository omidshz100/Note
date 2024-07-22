//
//  Home.swift
//  Note
//
//  Created by Omid Shojaeian Zanjani on 20/07/24.
//

import SwiftUI
import SwiftData

struct Home: View {
    // List Selection ( going to use this as a Tab to Filter the selected category
    @State private var selectedTag:String? = "All Notes"
    // Quering all Categories
    @Query(animation: .snappy) private var categories:[NoteCategory]
    @Environment(\.modelContext) private var context
    // View Property
    @State private var addCategory:Bool = false
    @State private var categoryTitle:String = ""
    @State private var requestedCategory: NoteCategory?
    @State private var deleteRequest:Bool = false
    @State private var renameRequest:Bool = false
    // light - dark mode
    @State private var isDark:Bool = true
    var body: some View {
        NavigationSplitView{
            List(selection: $selectedTag) {
                Text("All Notes")
                    .tag("All Notes")
                    .foregroundStyle(selectedTag == "All Notes" ? Color.primary: .gray)
                
                Text("Favorites")
                    .tag("Favorites")
                    .foregroundStyle(selectedTag == "Favorites" ? Color.primary: .gray)
                
                // User created category
                Section{
                    ForEach(categories){ categoryItem in
                        Text(categoryItem.categoryTitle)
                            .tag(categoryItem.categoryTitle)
                            .foregroundStyle(selectedTag == categoryItem.categoryTitle  ? Color.primary: .gray)
                        // some basic edditing options
                            .contextMenu(menuItems: {
                                Button("Rename"){
                                    // placing the already having title in the textfield
                                    categoryTitle = categoryItem.categoryTitle
                                    requestedCategory = categoryItem
                                    renameRequest = true
                                }
                                Button("Delete"){
                                    categoryTitle = categoryItem.categoryTitle
                                    requestedCategory = categoryItem
                                    deleteRequest = true
                                }
                            })
                    }
                }header: {
                    HStack(spacing: 5, content: {
                        Text("Categories")
                        
                        Button("", systemImage: "plus"){
                            addCategory.toggle()
                        }
                        .tint(.gray)
                        .buttonStyle(PlainButtonStyle())
                    })
                }
            }
        }detail: {
            // notes View with Dynamic Filtering based on the category
            NoteView(category: selectedTag, allCategories: categories)
        }
        .navigationTitle(selectedTag ?? "Notes")
        // Add category alert
        .alert("Add Category", isPresented: $addCategory) {
            // from macOS 13 we can use TextField directly inside the Alert
            TextField("Word", text: $categoryTitle)
            
            Button("Cancel", role: .cancel) {
                categoryTitle = ""
            }
            
            Button("Add") {
                // adding new category to the swiftData
                let category = NoteCategory(categoryTitle: categoryTitle)
                context.insert(category)
                categoryTitle = ""
            }
        }
        // rename category alert
        .alert("Rename Category", isPresented: $renameRequest){
            TextField("New name", text: $categoryTitle)
            
            
            
            Button("Cancel", role: .cancel){
                categoryTitle = ""
                requestedCategory = nil
            }
            
            Button("Rename"){
                if let requestedCategory {
                    requestedCategory.categoryTitle = categoryTitle
                    categoryTitle = ""
                    self.requestedCategory = nil
                }
            }
        }
        // Delete category alert
        .alert("Are you sure to delete \(categoryTitle) category?", isPresented: $deleteRequest){
            
            Button("Cancel", role: .cancel){
                categoryTitle = ""
                requestedCategory = nil
            }
            
            Button("Delete", role: .destructive){
                if let requestedCategory {
                    context.delete(requestedCategory)
                    categoryTitle = ""
                    self.requestedCategory = nil
                }
            }
        }
        // toolbar Items
        .toolbar{
            ToolbarItem(placement: .primaryAction){
                HStack(spacing: 10){
                    Button("", systemImage:"plus"){
                        // adding new notes
                        let note = Note(content: "")
                        context.insert(note)
                    }
                    
                    Button("", systemImage: isDark ? "sun.min":"moon"){
                        // Dark or lighr mode
                        
                        isDark.toggle()
                    }
                    .contentTransition(.symbolEffect(.replace))
                }
            }
        }
        .preferredColorScheme(isDark ? .dark:.light)
    }
}

#Preview {
    Home()
}
