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
    
    @State private var date : Date
    
    init(event: Event) {
        self.event = event
        self._date = State(initialValue: event.wrappedTimestamp)
    }
    
    var body: some View {
        
        return NavigationView {
            VStack {
                Form {
                    Section {
                        DatePicker(selection: $date, in: ...Date(), displayedComponents: [.hourAndMinute, .date]) {
                            Text("Time")
                        }
                        .datePickerStyle(GraphicalDatePickerStyle())
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
}
