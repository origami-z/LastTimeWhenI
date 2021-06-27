//
//  Entry+CoreDataProperties.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 29/05/2020.
//  Copyright © 2020 zhihaocui. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI


extension Entry {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }
    
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var events: NSSet?
    
    @NSManaged public var lastUpdateTime: Date?
    
    public var wrappedName: String {
        name ?? "Unknown name"
    }
    
    public var wrappedImage: Image {
        if image != nil, let uiImage = UIImage(data: image!) {
            return Image(uiImage:uiImage)
        }
        else {
            return Image("Camera")
        }
    }
    
    public var sortedEvents: Array<Event> {
        let set = events as? Set<Event> ?? []
        return set.sorted {
            $0.wrappedTimestamp > $1.wrappedTimestamp
        }
    }
}

// MARK: Generated accessors for events
extension Entry {
    
    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)
    
    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)
    
    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)
    
    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)
    
}

extension Entry {
    static func create(in managedObjectContext: NSManagedObjectContext, name: String, image: Data?, events: [Event]? ){
        let newEntry = self.init(context: managedObjectContext)
        newEntry.name = name
        newEntry.image = image// ?? (UIImage(named: "Camera")?.pngData())!
        
        newEntry.lastUpdateTime = events?.first?.timestamp
        
        events?.forEach {
            newEntry.addToEvents($0)
        }
        
        do {
            try  managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    public func newEvent(in managedObjectContext: NSManagedObjectContext, at timestamp : Date = Date()) {
        let event = Event.init(context: managedObjectContext)
        event.timestamp = timestamp
        self.addToEvents(event)
        self.lastUpdateTime = Date()
        //        self.lastEventTimestamp = timestamp
        
        do {
            try  managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

extension Collection where Element == Entry, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        
        indices.forEach {
            managedObjectContext.delete(self[$0])
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

