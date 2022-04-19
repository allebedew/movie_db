//
//  MovieDBApp.swift
//  MovieDB
//
//  Created by Alex on 19.04.2022.
//

import SwiftUI

@main
struct MovieDBApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    init() {
        print("app init")
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    var body: some Scene {
        WindowGroup {
            TVShowList()
                .onOpenURL { print("open url: \($0)") }
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .background:
                print("app state: background")
            case .inactive:
                print("app state: inactive")
            case .active:
                print("app state: active")
            @unknown default:
                print("app state: unknown")
            }
        }
    }
}
