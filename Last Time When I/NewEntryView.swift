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
                        
                        DatePicker(selection: $date, in: ...Date(), displayedComponents: [.hourAndMinute, .date]) {
                            Text("Time")
                        }
                        
                        Button(action: {
                            self.showCaptureImageView.toggle()
                        }) {
                            VStack(alignment: .center) {
                                imageToDisplay?
                                    .resizable()
                                    .squareImage()
                                    .frame(width: 250, height: 250)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 10)
                                Text("Choose a picture")
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    }
                }
            }
            .navigationBarItems(
                leading: Button(action: cancelAndDismiss) {
                    Text("Cancel")
                },
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
    
    func cancelAndDismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func saveEntryAndDismiss() {
        let newEvent = Event.init(context: self.viewContext)
        newEvent.timestamp = self.date
        
        let entryImage = self.image ?? UIImage(named: "Camera")!
        
        Entry.create(in: self.viewContext, name: self.name, image: entryImage.pngData()!, events: [newEvent])
        
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
