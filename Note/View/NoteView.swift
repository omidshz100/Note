//
//  NoteView.swift
//  Note
//
//  Created by Omid Shojaeian Zanjani on 22/07/24.
//

import SwiftUI
import SwiftData


struct NoteView: View {
    var category:String?
    @Query private var notes:[Note]
    var allCategories:[NoteCategory]
    init(category: String?, allCategories:[NoteCategory]) {
        self.category = category
        self.allCategories = allCategories
        
        
        let predicate = #Predicate<Note>{
            return $0.category?.categoryTitle == category
        }
        
        let isFavoritePredicate = #Predicate<Note>{
            return $0.isFavorite
        }
        
        let finalPredicate = category == "All Notes" ? nil: (category == "Favorites" ? isFavoritePredicate: predicate)
        
        _notes = Query(filter: finalPredicate, sort: [], animation: .snappy)
    }
    
    @FocusState private var isKeyboardEnd:Bool
    @Environment(\.modelContext) private var context
    var body: some View {
        GeometryReader{
            let size = $0.size
            let width = size.width
            // Dynamic Grid count base on th eavailibility size
            let rowCount = max(Int(width / 250), 1)
            
            ScrollView{
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: rowCount), spacing: 10) {
                    ForEach(notes){ note in
                        NoteCardView(note: note, isKeyBoardEnabled: $isKeyboardEnd)
                            .contextMenu{
                                Button(note.isFavorite ? "Remove from Favorite":"Add to favorite"){
                                    note.isFavorite.toggle()
                                }
                                
                                Menu {
                                    ForEach(allCategories){ category in
                                        Button {
                                            // updating category
                                            note.category = category
                                        } label: {
                                            HStack(spacing: 5) {
                                                if category == note.category {
                                                    Image(systemName: "checkmark")
                                                        .font(.caption)
                                                }
                                                Text(category.categoryTitle)
                                            }
                                        }

                                    }
                                    
                                    Button {
                                        note.category = nil
                                    } label: {
                                        Text("remove from categories")
                                    }

                                } label: {
                                    Text("Categories")
                                }

                                Button(role: .destructive) {
                                    context.delete(note)
                                } label: {
                                    Text("remove Note")
                                }

                            }
                    }
                }
            }
            .padding(12)
        }// End of Geometry
        .onTapGesture {
            isKeyboardEnd = false
        }
    }
}

struct NoteCardView:View {
    @Bindable  var note:Note
    var isKeyBoardEnabled:FocusState<Bool>.Binding
    @State private var showNote:Bool = false
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.clear)
            
            if showNote {
                TextEditor(text: $note.content)
                    .focused(isKeyBoardEnabled)
                    .overlay(content: {
                        Text("Finish work")
                            .foregroundStyle(.gray)
                            .padding(12)
                            .opacity(note.content.isEmpty ? 1:0)
                            .allowsHitTesting(false)
                    })
                    .scrollContentBackground(.hidden)
                    .multilineTextAlignment(.leading)
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 12))
            }
        }
        .onAppear(){
            showNote = true
        }
        .onDisappear(){
            showNote = false
        }
        
    }
}
#Preview {
    ContentView()
}
