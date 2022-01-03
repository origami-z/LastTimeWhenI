//
//  Persistence.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 06/06/2021.
//  Copyright © 2021 zhihaocui. All rights reserved.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        for index in 0..<20 {
            let event = Event.init(context: viewContext)
            event.timestamp = Date().addingTimeInterval(TimeInterval(index * -30000 - 2500 ))
            
            Entry.create(in: viewContext, name: "Hello World \(index)", image: nil, events: [event])
            
            //        let entry = Entry.init(context: context)
            //        entry.name = "Hello World \(Int.random(in: 0..<10))"
            //        entry.image = (UIImage(named: "Camera")?.pngData())
            //        entry.addToEvents(event)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Last_Time_When_I")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
