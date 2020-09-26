//
//  TimeEditorView.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 25/09/2020.
//  Copyright © 2020 zhihaocui. All rights reserved.
//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

struct TimeEditorView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var event: Event
    
    @State private var date = Date()    
    
    var body: some View {
        
        return NavigationView {
            VStack {
                Form {
                    Section {
                        if #available(iOS 14.0, *) {
                            DatePicker(selection: $date, in: ...Date(), displayedComponents: [.hourAndMinute, .date]) {
                                Text("Time")
                            }
                            .datePickerStyle(GraphicalDatePickerStyle())
                        } else {
                            DatePicker(selection: $date, in: ...Date(), displayedComponents: [.hourAndMinute, .date]) {
                                Text("Time")
                            }
                            .datePickerStyle(WheelDatePickerStyle())
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Update Time"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    print("Dismissing sheet view...")
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel").bold()
                },
                trailing: Button(action: {
                    print("Dismissing sheet view...")
                    //                    self.isSheetShown = false
                    self.event.updateTime(in: self.viewContext, to: self.date)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done").bold()
                })
        }
    }
    
    init(event: Event) {
        self.event = event
        self.date = event.wrappedTimestamp
    }
}

//struct TimeEditorView_Previews: PreviewProvider {
//
//    @State var showTimeEditorSheet: Bool = true
//
//    static var previews: some View {
//
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        let entry = Entry.init(context: context)
//        entry.name = "Entry name \(Int.random(in: 1..<10))"
//        entry.image = (UIImage(named: "Camera")?.pngData())
//
//        //        let event = Event.init(context: context)
//        //        event.timestamp = Date()
//        //        entry.addToEvents(event)
//        //
//        //        let event2 = Event.init(context: context)
//        //        event2.timestamp = Date() + 153 * 60 * 60
//        //        entry.addToEvents(event2)
//
//        let event = Event.init(context: context)
//        event.timestamp = Date() +  TimeInterval(153 * 60 * 60 * 0)
//        entry.addToEvents(event)
//
//        return
//            Group {
//                TimeEditorView(isShown: true, event: event)
//                    .environment(\.managedObjectContext, context)
//            }
//    }
//}
