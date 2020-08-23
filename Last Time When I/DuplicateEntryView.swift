//
//  DuplicateEntryView.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 23/08/2020.
//  Copyright © 2020 zhihaocui. All rights reserved.
//

import SwiftUI
import CoreData

struct DuplicateEntryView : View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var sourceEntry: Entry
    
    @State var name: String = ""
    @State var showCaptureImageView: Bool = false
    @State var image: UIImage? = nil
    
    var imageToDisplay: Image? {
        image == nil ? Image("Camera") : Image(uiImage: image!)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Name", text: $name)
                    
                    Button(action: {
                        self.showCaptureImageView.toggle()
                    }) {
                        VStack(alignment: .center) {
                            imageToDisplay?.resizable()
                                .renderingMode(.original)
                                .frame(width: 250, height: 250)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                            Text("Choose photos")
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
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
        let duplicatedEvents: [Event] = sourceEntry.sortedEvents.map{ event in
            let newEvent = Event.init(context: self.viewContext)
            newEvent.timestamp = event.timestamp
            return newEvent
        }
        
        let entryImage = self.image ?? UIImage(named: "Camera")!
        
        Entry.create(in: self.viewContext, name: self.name, image: entryImage.pngData()!, events: duplicatedEvents)
        
        self.presentationMode.wrappedValue.dismiss()
    }
}
