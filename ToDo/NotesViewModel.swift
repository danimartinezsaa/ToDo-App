//
//  NoteViewMode.swift
//  ToDo
//
//  Created by Dani on 26/1/22.
//

import Foundation
import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [NoteModel] = []
    
    init() {
        notes = getAllNotes()
    }
    
    func saveNote(description: String) {
        let newNote = NoteModel(description: description)
        notes.insert(newNote, at: 0)
        encodeAndSaveAllNotes()
    }
    
    private func encodeAndSaveAllNotes() {
        guard let encoded = try? JSONEncoder().encode(notes) else {return}
        UserDefaults.standard.set(encoded, forKey: "notes")
    }
    
    func getAllNotes() -> [NoteModel] {
        guard let notesData = UserDefaults.standard.object(forKey: "notes") as? Data,
              let notes = try? JSONDecoder().decode([NoteModel].self, from: notesData)
        else {
            return []
        }
        
        return notes
    }
    
    func removeNote(withId id: String) {
        notes.removeAll(where: {$0.id == id})
        encodeAndSaveAllNotes()
    }
    
    func updateFavoriteNote(note: Binding<NoteModel>) {
        note.wrappedValue.isFavorited = !note.wrappedValue.isFavorited
        encodeAndSaveAllNotes()
    }
    
    func getNumberOfNotes() -> String {
        "\(notes.count)"
    }

}
