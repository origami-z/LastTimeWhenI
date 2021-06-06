//
//  LastTimeWhenIApp.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 06/06/2021.
//  Copyright © 2021 zhihaocui. All rights reserved.
//

import SwiftUI

@main
struct LastTimeWhenIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            EntryListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
