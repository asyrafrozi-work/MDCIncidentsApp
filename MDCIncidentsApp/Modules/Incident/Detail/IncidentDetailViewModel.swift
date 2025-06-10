//
//  IncidentDetailViewModel.swift
//  MDCIncidentsApp
//
//  Created by Asyraf Rozi on 10/06/2025.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

class IncidentDetailViewModel {
    // Inputs
    let incident: Incident
    
    // Outputs
    let mapRegion: BehaviorRelay<MKCoordinateRegion>
    let descriptionCopied: PublishRelay<Void> = PublishRelay()
    
    init(incident: Incident) {
        self.incident = incident
        self.mapRegion = BehaviorRelay(value: MKCoordinateRegion(
            center: incident.location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    func copyDescription() {
        UIPasteboard.general.string = incident.description
        descriptionCopied.accept(())
    }
    
    func openInMaps() {
        let coordinate = incident.location.coordinate
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = incident.title
        
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
} 
