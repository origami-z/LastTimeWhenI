//
//  Event+CoreDataProperties.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 25/05/2020.
//  Copyright © 2020 zhihaocui. All rights reserved.
//
//

import Foundation
import CoreData

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

extension Event {

    // This throws error on SwiftUI preview: replaced function 'fetchRequest()' is not marked dynamic on XCode Version 11.5 (11E608c)
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
//        return NSFetchRequest<Event>(entityName: "Event")
//    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var entry: Entry?

    public var wrappedTimestamp : Date {
        timestamp ?? Date.init(timeIntervalSince1970: TimeInterval())
    }
    
    public var formattedTimestamp: String {
        dateFormatter.string(from: wrappedTimestamp)
    }
    
    public func updateTime(in managedObjectContext: NSManagedObjectContext, to newTime: Date) {
        self.timestamp = newTime
        self.entry?.lastUpdateTime = Date()
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

extension Event {
    static func create(in managedObjectContext: NSManagedObjectContext, time: Date){
        let newEvent = self.init(context: managedObjectContext)
        newEvent.timestamp = time
        
        do {
            try  managedObjectContext.save()
//            return newEvent
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

// Needed for List().sheet()
extension Event: Identifiable {
    
}

extension Collection where Element == Event, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        
        indices.forEach {
            managedObjectContext.delete(self[$0])
            self[$0].entry?.lastUpdateTime = Date()
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

