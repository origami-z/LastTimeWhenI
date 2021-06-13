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


private let relativeDateTimeFormatter = RelativeDateTimeFormatter()

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
    
    /// Returns formatted time with medium date style and short time style
    ///
    /// e.g. `Jul 11, 2021 at 7:34 PM`
    public var formattedTimestamp: String {
        dateFormatter.string(from: wrappedTimestamp)
    }
    
    /// Returns localized relative time, e.g. `x hours ago`
    public var relativeDateTime: String {
        relativeDateTimeFormatter.localizedString(for: wrappedTimestamp, relativeTo: Date())
    }
    
    public func updateTime(in managedObjectContext: NSManagedObjectContext, to newTime: Date) {
        self.timestamp = newTime
        self.entry?.lastUpdateTime = self.entry?.sortedEvents.first?.timestamp

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

