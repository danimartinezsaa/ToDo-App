//
//  ContentView.swift
//  ToDo
//
//  Created by Dani on 26/1/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var descriptionNote: String = ""
    @StateObject var notesViewModel = NotesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add new task")
                    .underline()
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                TextEditor(text: $descriptionNote)
                    .foregroundColor(.gray)
                    .frame(height: 180)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.green, lineWidth: 2)
                    )
                    .padding(.horizontal, 12)
                    .cornerRadius(3.0)
                Button("Create") {
                    notesViewModel.saveNote(description: descriptionNote)
                    descriptionNote = ""
                }
                .buttonStyle(.bordered)
                .tint(.green)
                Spacer()
                List {
                    ForEach($notesViewModel.notes, id: \.id) { $note in
                        HStack {
                            if note.isFavorited {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                            Text(note.description)
                        }
                        .swipeActions(edge: .trailing) {
                                Button {
                                    notesViewModel.updateFavoriteNote(note: $note)
                                } label: {
                                    Label("Favorite", systemImage: "star.fill")
                                }
                                .tint(.yellow)
                        }
                        .swipeActions(edge: .leading) {
                                Button {
                                    notesViewModel.removeNote(withId: note.id)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                                .tint(.red)
                        }
                    }
                }
            }
            .navigationTitle("TODO")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Text(notesViewModel.getNumberOfNotes())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
