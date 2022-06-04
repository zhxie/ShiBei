//
//  ShiBeiApp.swift
//  Shared
//
//  Created by 谢之皓 on 2022/6/4.
//

import SwiftUI

@main
struct ShiBeiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
