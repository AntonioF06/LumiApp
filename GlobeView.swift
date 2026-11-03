import SwiftUI
@_spi(Experimental) import MapboxMaps // Enables the native SwiftUI Map wrapper

// Simple model to trigger the popup sheet
struct SelectedCountry: Identifiable {
    let id = UUID()
    let name: String
    let isoCode: String
}

struct GlobeView: View {
    @State private var selectedCountry: SelectedCountry?
    
    // Set initial camera to view the whole globe
    @State private var viewport: Viewport = .camera(
        center: CLLocationCoordinate2D(latitude: 20, longitude: 0),
        zoom: 1.5
    )
    var body: some View {
        MapReader { proxy in
            // 1. Notice the { } closure added to the Map initialization
            Map(viewport: $viewport) {
                TapInteraction(.layer("country-fills")) { queriedFeature, context in
                    
                    // Notice we now call 'queriedFeature.properties' directly!
                    // We also use the '?' at the end of the case match to handle Swift optionals cleanly.
                    if case let .string(name)? = queriedFeature.properties["name_en"],
                       case let .string(iso)? = queriedFeature.properties["iso_3166_1_alpha_3"] {
                        
                        // Trigger the popup
                        self.selectedCountry = SelectedCountry(name: name, isoCode: iso)
                        
                        // Highlight the tapped country on the map
                        if let mapboxMap = proxy.map {
                            highlightCountry(mapboxMap: mapboxMap, isoCode: iso)
                        }
                        
                        // Smoothly animate camera to the tapped location
                        withViewportAnimation(.default(maxDuration: 1.2)) {
                            viewport = .camera(center: context.coordinate, zoom: 3.5)
                        }
                        
                        return true // Stops the tap from passing through
                    }
                    
                    return false // Ignores the tap if it didn't find the correct properties
                }
            }
            .mapStyle(.light)
            .onMapLoaded { _ in
                guard let mapboxMap = proxy.map else { return }
                setupCustomGlobe(mapboxMap: mapboxMap)
            }
            .ignoresSafeArea()
        }
        .sheet(item: $selectedCountry) { country in
            CountryPopupView(country: country)
                .presentationDetents([.height(250), .medium])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled(upThrough: .height(250)))
        }
    }
    
    // MARK: - Mapbox Customization & Layer Setup
    private func setupCustomGlobe(mapboxMap: MapboxMap) {
        do {
            // A. Force 3D Globe Projection
            try mapboxMap.setProjection(StyleProjection(name: .globe))
            
            // B. Customize the Space Background & Atmosphere Halo
            var atmosphere = Atmosphere()
            atmosphere.color = .constant(StyleColor(UIColor(red: 0.1, green: 0.1, blue: 0.25, alpha: 1.0))) // Lower atmosphere glow
            atmosphere.highColor = .constant(StyleColor(UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0))) // Upper atmosphere
            atmosphere.spaceColor = .constant(StyleColor(UIColor(red: 0.02, green: 0.02, blue: 0.05, alpha: 1.0))) // Deep space background
            atmosphere.starIntensity = .constant(0.8) // Controls visible stars in the background!
            try mapboxMap.setAtmosphere(atmosphere)
            
            // C. Add Mapbox's Built-in Country Boundaries Dataset
            var source = VectorSource(id: "countries-source")
            source.url = "mapbox://mapbox.country-boundaries-v1"
            try mapboxMap.addSource(source)
            
            // D. Add invisible (or tinted) fill layer to detect taps and show highlights
            var fillLayer = FillLayer(id: "country-fills", source: "countries-source")
            fillLayer.sourceLayer = "country_boundaries"
            fillLayer.fillColor = .constant(StyleColor(.systemBlue))
            fillLayer.fillOpacity = .constant(0.0) // Start invisible until tapped
            try mapboxMap.addLayer(fillLayer)
            
            // E. Add custom stylized country borders
            var lineLayer = LineLayer(id: "country-borders", source: "countries-source")
            lineLayer.sourceLayer = "country_boundaries"
            lineLayer.lineColor = .constant(StyleColor(UIColor.systemBlue.withAlphaComponent(0.5)))
            lineLayer.lineWidth = .constant(1.0)
            try mapboxMap.addLayer(lineLayer)
            
        } catch {
            print("Failed to configure Mapbox style: \(error)")
        }
    }
    
    // MARK: - Highlight Selected Country
    private func highlightCountry(mapboxMap: MapboxMap, isoCode: String) {
        do {
            // Native v11 way to update layer properties using strongly-typed layers
            try mapboxMap.updateLayer(withId: "country-fills", type: FillLayer.self) { layer in
                
                let opacityExpression = Exp(.switchCase) {
                    Exp(.eq) {
                        Exp(.get) { "iso_3166_1_alpha_3" }
                        isoCode
                    }
                    0.5 // Opacity for selected country
                    0.0 // Opacity for all other countries
                }
                
                // Assign the expression directly without converting to JSON
                layer.fillOpacity = .expression(opacityExpression)
            }
        } catch {
            print("Failed to highlight country: \(error)")
        }
    }
}

// MARK: - Popup View
struct CountryPopupView: View {
    let country: SelectedCountry
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(country.name)
                        .font(.title2.bold())
                    Text("ISO: \(country.isoCode)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.gray.opacity(0.6))
                }
            }
            Divider()
            Text("Future app features for \(country.name) will appear here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(24)
    }
}

#Preview{
    GlobeView()
}
