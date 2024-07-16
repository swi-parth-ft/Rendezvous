//
//  EditView.swift
//  Rendezvous
//
//  Created by Parth Antala on 2024-07-16.
//

import SwiftUI

struct EditView: View {
    
    
    @State private var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    
    
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Neaerby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(" : ") +
                            Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("save") {
                    
                    var newLocation = viewModel.location
                    newLocation.id = UUID()
                    newLocation.name = viewModel.name
                    newLocation.description = viewModel.description
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        
        _viewModel = State(wrappedValue: ViewModel(location: location))
                self.onSave = onSave
        
        
    }
}

extension EditView {
    
    @Observable
    class ViewModel {
        enum LoadingState {
            case loading, loaded, failed
        }
        
        var loadingState = LoadingState.loading
        var pages = [Page]()
        var name: String
        var description: String
        var location: Location
        
        init(location: Location) {
            self.location = location
            self.name = location.name
            self.description = location.description
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                // we got some data back!
                let items = try JSONDecoder().decode(Result.self, from: data)

                // success – convert the array values to our pages array
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                // if we're still here it means the request failed somehow
                loadingState = .failed
            }
        }
    }
    
}
#Preview {
    EditView(location: .example) { _ in
         
    }
}
