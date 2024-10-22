//
//  Maps.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 11/10/2024.
//

import MapKit
import SwiftUI


/// https://www.hackingwithswift.com/100/swiftui/70
struct Maps: View {

    @State private var selectedPlace: Location?

    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )

    @State var currentRegion: MKCoordinateRegion?
    @State var tappedCenter: CLLocationCoordinate2D?

    @State var locations = [
        Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]

    var body: some View {
        MapReader { proxy in
            Map(position: $position) {
                ForEach(locations) { location in
                    Group {
//                        Marker(location.name, coordinate: location.coordinate)
// OR
//                        Annotation(location.name, coordinate: location.coordinate) {
//                            Text(location.name)
//                                .font(.headline)
//                                .padding()
//                                .background(.blue)
//                                .foregroundStyle(.white)
//                                .clipShape(.capsule)
//                        }
//                        .annotationTitles(.hidden)
// OR
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(.circle)
// May not work
//                                .onLongPressGesture {
//                                    selectedPlace = location
//                                }
// So that is workaround
                                .simultaneousGesture(LongPressGesture(minimumDuration: 1)
                                    .onEnded { _ in
                                        selectedPlace = location
                                    }
                                )
                        }
                    }
                }
            }
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    tappedCenter = coordinate

                    let newLocation = Location(
                        name: "New location",
                        coordinate: CLLocationCoordinate2D(
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude
                        ))
                    locations.append(newLocation)
                }
            }
            .onMapCameraChange(frequency: .continuous) { context in
                currentRegion = context.region
            }
            .sheet(item: $selectedPlace) { place in
                EditView(location: place) { newLocation in
                    if let index = locations.firstIndex(of: place) {
                        locations[index] = newLocation
                    }
                }
            }
        }

        HStack(spacing: 50) {
            Button("Paris") {
                position = MapCameraPosition.region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                    )
                )
            }

            Button("Tokyo") {
                position = MapCameraPosition.region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922),
                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                    )
                )
            }
        }

        HStack {
            Text("Current region:")
            Text(currentRegion?.center.latitude.formatted() ?? "")
            Text(currentRegion?.center.longitude.formatted() ?? "")
        }

        HStack {
            Text("Tapped:")

            if let tappedCenter {
                Text(tappedCenter.latitude.formatted())
                Text(tappedCenter.longitude.formatted())
            } else {
                Text("Tap somewhere om the map")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    Maps()
}

// MARK: - Location

struct Location: Identifiable {
    var id = UUID()
    var name: String
    var description: String = ""
    var coordinate: CLLocationCoordinate2D

    var latitude: CLLocationDegrees {
        coordinate.latitude
    }

    var longitude: CLLocationDegrees {
        coordinate.longitude
    }
}

extension Location: Equatable {
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

#if DEBUG
    static let example = Location(
        id: UUID(),
        name: "Buckingham Palace",
        description: "Lit by over 40,000 lightbulbs.",
        coordinate: CLLocationCoordinate2D(
            latitude: 51.501,
            longitude: -0.141
        )
    )
#endif
}

// MARK: - EditView

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void

    @State private var name: String
    @State private var description: String

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description

                    onSave(newLocation)
                    dismiss()
                }
            }
        }
    }

    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave

        self._name = State(initialValue: location.name)
        self._description = State(initialValue: location.description)
    }
}

#Preview("EditView") {
    EditView(location: .example) { _ in }
}
