//
//  NewEntryView.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 25/05/2020.
//  Copyright © 2020 zhihaocui. All rights reserved.
//

import SwiftUI
import CoreData

struct NewEntryView: View {
    //    @State var entry: Entry
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var date = Date()
    
    @State var name: String = ""
    @State var showCaptureImageView: Bool = false
    @State var image: UIImage? = nil
    
    var imageToDisplay: Image? {
        image == nil ? Image("Camera") : Image(uiImage: image!)
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Name", text: $name)
                        
                        //                        ForEach(entry.events.array as! [Event], id:\.self) { event in
                        //
                        //                        }
                        
                        DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
                            Text("Select a date")
                        }
                        
                        //
                        //                        Picker("Rating", selection: $rating) {
                        //                            ForEach(ratings, id: \.self) { rating in
                        //                                Text(rating)
                        //                            }
                        //                        }
                    }
                }
                Button(action: {
                    self.showCaptureImageView.toggle()
                }) {
                    Text("Choose photos")
                }
                imageToDisplay?.resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                
            }
            .navigationBarItems(
//                                leading: EditButton()
                                trailing: Button(
                                    action: saveEntryAndDismiss
                                ) {
                                    Image(systemName: "plus")
                                }
                            )
        }
            
        .sheet(isPresented: $showCaptureImageView) {
            CaptureImageView(isShown: self.$showCaptureImageView, image: self.$image)
        }
    }
    
    func saveEntryAndDismiss() {
//        let newEvent = Event.create(in: self.viewContext, time: self.date)
        let newEvent = Event.init(context: self.viewContext)
        newEvent.timestamp = self.date
        
        let entryImage = self.image ?? UIImage(named: "Camera")!
        
        Entry.create(in: self.viewContext, name: self.name, image: entryImage.pngData()!, event: newEvent)
//
//        let entry = Entry.init(context: self.viewContext)
//        entry.name = self.name
//        entry.image = entryImage.pngData()
//        entry.addToEvents(newEvent)
//
//        try? viewContext.save()
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct NewEntryView_Previews: PreviewProvider {
    static var previews: some View {
        //        let entry = Entry(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        //
        //
        //        entry.name = ""
        
        //        let event = Event(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        //        event.timestamp = Date()
        //
        //        entry.addToEvents(event)
        
        return NewEntryView()
    }
}
