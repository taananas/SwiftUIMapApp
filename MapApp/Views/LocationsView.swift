//
//  LocationsView.swift
//  MapApp
//
//  Created by Богдан Зыков on 17.04.2022.
//

import SwiftUI
import MapKit


struct LocationsView: View {
    @EnvironmentObject var vm: LocationsViewModel
    var body: some View {
        ZStack{
            mapLayer
            VStack(spacing: 0){
                header
                Spacer()
                locationPreviewStack
            }
        }
        .sheet(item: $vm.sheetLocation) { location in
            LocationDetailView(location: location)
        }
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView()
            .environmentObject(LocationsViewModel())
    }
}


extension LocationsView {
    private var header: some View{
        VStack {
            Button {
                vm.toggleLocationList()
            } label: {
                Text(vm.mapLocation.name + ", " + vm.mapLocation.cityName)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: vm.mapLocation)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: vm.showLocationList ? 180 : 0))
                    }
            }

            if vm.showLocationList{
                LocationListView()
            }
        }
        .background(.thinMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
        .padding()
    }
    private var mapLayer: some View{
        Map(coordinateRegion: $vm.mapRegion,
            annotationItems: vm.locations,
            annotationContent: { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                    .shadow(radius: 10)
                    .onTapGesture {
                        vm.showNextLocation(location: location)
                    }
            }
            
        })
            .ignoresSafeArea()
    }
    private var locationPreviewStack: some View{
        ZStack{
            ForEach(vm.locations){location in
                if vm.mapLocation == location{
                    LocationPreviewView(location: location)
                        .shadow(color: .black.opacity(0.2), radius: 20)
                        .padding()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                }
            }
        }
    }
}
