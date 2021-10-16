//
//  DuplicateEntryView.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 23/08/2020.
//  Copyright © 2020 zhihaocui. All rights reserved.
//

import SwiftUI
import CoreData

struct EditEntryView : View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var sourceEntry: Entry
    
    @State var name: String
    @State var showImagePicker: Bool = false
    @State var image: UIImage?
    
    var imageToDisplay: Image? {
        image == nil ? Image("Camera") : Image(uiImage: image!)
    }
    
    init(entry: Entry) {
        self.sourceEntry = entry
        self._name = State(initialValue: entry.name ?? "New Entry")
        self._image = State(initialValue: entry.image != nil ? UIImage(data: entry.image!) : nil)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Name", text: $name)
                    
                    Button(action: {
                        self.showImagePicker.toggle()
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
                    action: updateEntryAndDismiss
                ) {
                    Text("Done")
                }
            )
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$image, sourceType: .photoLibrary)
        }
    }
    
    func cancelAndDismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func updateEntryAndDismiss() {
        sourceEntry.update(name: self.name, image: self.image!, in: self.viewContext)
        
        self.presentationMode.wrappedValue.dismiss()
    }
}
