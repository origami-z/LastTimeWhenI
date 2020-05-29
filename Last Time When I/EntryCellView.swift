//
//  EntryCellView.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 29/05/2020.
//  Copyright © 2020 zhihaocui. All rights reserved.
//

import SwiftUI

//private let dateFormatter: DateFormatter = {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateStyle = .medium
//    dateFormatter.timeStyle = .short
//    return dateFormatter
//}()

struct EntryCellView: View {
    @ObservedObject var entry: Entry

    var body: some View {
        HStack {
            entry.wrappedImage
                .resizable()
                .frame(width: 80, height: 80)
            
            VStack(alignment: .leading) {
                Text(entry.wrappedName)
                if (entry.sortedEvents.first != nil) {
                    Text(entry.sortedEvents.first!.formattedTimestamp)
                }
            }
        }
    }
}

struct EntryCellView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
        //        let event = Event.create(in: context, time: Date())
                let event = Event.init(context: context)
                event.timestamp = Date()
                
//                Entry.create(in: context, name: "Hello World \(Int.random(in: 0..<10))", image: (UIImage(named: "Camera")?.pngData())!, event: event)
                
                let entry = Entry.init(context: context)
                entry.name = "Entry name \(Int.random(in: 1..<10))"
                entry.image = (UIImage(named: "Camera")?.pngData())
                entry.addToEvents(event)
                
        return EntryCellView(entry: entry) // .environment(\.managedObjectContext, context)
    }
}
