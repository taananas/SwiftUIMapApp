//
//  LocationsViewModel.swift
//  MapApp
//
//  Created by Богдан Зыков on 17.04.2022.
//

import Foundation
import MapKit
import SwiftUI

class LocationsViewModel: ObservableObject{
    
    @Published var locations: [Location]
    
    @Published var mapLocation: Location {
        didSet{
            updateMapRegion(location: mapLocation)
        }
    }
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    @Published var showLocationList: Bool = false
    @Published var sheetLocation: Location? = nil
    
    init(){
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self.updateMapRegion(location: locations.first!)
        
    }
    
    private func updateMapRegion(location: Location){
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: location.coordinates,
                span: mapSpan)
        }
    }
     func toggleLocationList(){
        withAnimation(.easeInOut){
            showLocationList = !showLocationList
        }
    }
    
    func showNextLocation(location: Location){
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationList = false
        }
    }
    func newButtonPress(){
        guard let currentIndex = locations.firstIndex(where: {$0 == mapLocation})else{return}
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex)else{
            guard let firstLocation = locations.first else {return}
            showNextLocation(location: firstLocation)
            return}
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
}
