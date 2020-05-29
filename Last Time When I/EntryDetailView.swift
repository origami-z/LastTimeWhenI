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
    
    var entry: Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            entry.wrappedImage
                .resizable()
                .frame(height: 200)
                .scaledToFit()
                .cornerRadius(8)
//            Text("\(entry.wrappedName)")
            
            EntryDetailHistoryListView(entry: self.entry)
            
            Spacer()
            
        }
        .padding()
        .navigationBarTitle(
            Text(entry.wrappedName),
            displayMode: .inline
        )
    }
}

struct EntryDetailHistoryListView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    var entry: Entry
    
    var eventsFetchRequest: FetchRequest<Event>
    var events: FetchedResults<Event> { eventsFetchRequest.wrappedValue }
    
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
//                        Text("hellow")
                        
                    }.onDelete { indices in
                        self.events.delete(at: indices, from: self.viewContext)
                    }
                }
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
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entry = Entry.init(context: context)
        entry.name = "Entry name \(Int.random(in: 1..<10))"
        entry.image = (UIImage(named: "Camera")?.pngData())
        
        //        let event = Event.init(context: context)
        //        event.timestamp = Date()
        //        entry.addToEvents(event)
        //
        //        let event2 = Event.init(context: context)
        //        event2.timestamp = Date() + 153 * 60 * 60
        //        entry.addToEvents(event2)
        
        for i in 0..<10 {
            let event = Event.init(context: context)
            event.timestamp = Date() +  TimeInterval(153 * 60 * 60 * i)
            entry.addToEvents(event)
        }
        
        return
            NavigationView {EntryDetailView(entry: entry)}
                .environment(\.managedObjectContext, context)
    }
}
