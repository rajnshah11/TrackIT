//
//  LocateUsView.swift
//  TrackIT
//
//  Created by Vrushali Shah on 4/17/24.
//
import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var region: MKCoordinateRegion
    @Binding var userLocation: CLLocation?
    var nearbyPlaces: [MKMapItem]?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.setRegion(region, animated: true)
        if let location = userLocation {
            centerCoordinate = location.coordinate
        }
        if let places = nearbyPlaces {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(places.map { $0.placemark })
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocation?
    @Published var nearbyPlaces: [MKMapItem]?

    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            findNearbyPlaces()
        case .denied, .restricted:
            // Inform the user and provide guidance
            showLocationAccessDeniedAlert()
        case .notDetermined:
            // Request authorization again
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        findNearbyPlaces()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }

    private func showLocationAccessDeniedAlert() {
        let alert = UIAlertController(
            title: "Location Access Denied",
            message: "Please enable location services for this app in Settings to use this feature.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }

    private func findNearbyPlaces() {
        guard let userLocation = userLocation else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "bank"
        request.region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 8047, longitudinalMeters: 8047) // 5 miles in meters
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error occurred in search: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.nearbyPlaces = response.mapItems
        }
    }
}

struct LocateUsView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ) // Default region (San Francisco)

    var body: some View {
        VStack {
            MapView(centerCoordinate: $region.center, region: $region, userLocation: $locationManager.userLocation, nearbyPlaces: locationManager.nearbyPlaces)
                .edgesIgnoringSafeArea(.all)

            Button("Find Banks near my location") {
                if let userLocation = locationManager.userLocation {
                    region.center = userLocation.coordinate
                }
            }
            .padding()
        }
    }
}

