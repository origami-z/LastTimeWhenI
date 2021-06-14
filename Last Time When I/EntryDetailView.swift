//
//  EntryDetailView.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 29/05/2020.
//  Copyright © 2020 zhihaocui. All rights reserved.
//

import SwiftUI

struct EntryDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.editMode) var editMode
    
    @ObservedObject var entry: Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            entry.wrappedImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .cornerRadius(8)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
            
            EntryDetailHistoryListView(entry: self.entry)
                .environment(\.editMode, Binding.constant(.inactive))
        }
        .navigationTitle(Text(entry.wrappedName))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                 EditButton()
            }
        }
        .sheet(isPresented: show(editMode)) {
            EditEntryView(entry: self.entry)
                .environment(\.managedObjectContext, self.viewContext)
        }
    }
    
    func show(_ value: Binding<EditMode>?) -> Binding<Bool> {
        Binding<Bool>(
            get: { value?.wrappedValue == .active  },
            set: { value?.wrappedValue = $0 ? .active : .inactive }
        )
    }
}

struct EntryDetailHistoryListView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    var entry: Entry
    
    var eventsFetchRequest: FetchRequest<Event>
    var events: FetchedResults<Event> { eventsFetchRequest.wrappedValue }
    
    @State var eventSelected: Event?
    
    var body: some View {
        List {
            Section(header: HStack {
                Text("History")
                
                Spacer()
                
                Button(
                    action: {
                    self.entry.newEvent(in: self.viewContext)
                }
                ) {
                    Image(systemName: "plus")
                }
            }) {
                ForEach(events, id: \.self) { event in
                    Text(event.formattedTimestamp)
                        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                            self.eventSelected = event
                        })
                }.onDelete { indices in
                    self.events.delete(at: indices, from: self.viewContext)
                }
            }
        }
        .sheet(item: $eventSelected) { item in
            TimeEditorView(event: item)
                .environment(\.managedObjectContext, self.viewContext)
        }
    }
    
    init(entry: Entry) {
        self.entry = entry
        eventsFetchRequest =  FetchRequest<Event>(
            entity: Event.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Event.timestamp, ascending: false)],
            predicate:  NSPredicate(format: "entry == %@", entry))
    }
}

struct EntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.preview.container.viewContext
        
        let entry = Entry.init(context: context)
        
        entry.name = "Entry name 10"
        entry.image = (UIImage(named: "Camera")?.pngData())
        
        for i in 0..<10 {
            let event = Event.init(context: context)
            event.timestamp = Date() +  TimeInterval(153 * 60 * 60 * i)
            entry.addToEvents(event)
        }
        
        return NavigationView {EntryDetailView(entry: entry)}.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
