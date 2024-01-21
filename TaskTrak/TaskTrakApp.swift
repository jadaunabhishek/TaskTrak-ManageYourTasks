//
//  TaskTrakApp.swift
//  TaskTrak
//
//  Created by Abhishek Jadaun on 21/01/24.
//

import SwiftUI

@main
struct TaskTrakApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
