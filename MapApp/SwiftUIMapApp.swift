//
//  SwiftUIMapApp.swift
//  MapApp
//
//  Created by Богдан Зыков on 17.04.2022.
//

import SwiftUI

@main
struct SwiftUIMapApp: App {
    @StateObject private var vm = LocationsViewModel()
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environmentObject(vm)
        }
    }
}
