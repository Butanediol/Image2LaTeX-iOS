//
//  Image2LatexApp.swift
//  Image2Latex
//
//  Created by Butanediol on 8/4/2021.
//

import SwiftUI

@main
struct Image2LatexApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
