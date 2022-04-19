//
//  ContentView.swift
//  MovieDB
//
//  Created by Alex on 19.04.2022.
//

import SwiftUI
import Combine

class TVShowListStore: ObservableObject {
    
    @Published private(set) var tvShows: [TVShow] = []
    @Published private(set) var isLoading: Bool = false

    private var subscriptions: Set<AnyCancellable> = []

    func fetch() {
        isLoading = false
        MovieDBAPI.shard.fetchPopularTVShows()
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .map { $0.results }
            .replaceError(with: [])
            .assign(to: \.tvShows, on: self)
            .store(in: &subscriptions)
    }
}

struct TVShowList: View {

    @ObservedObject var store = TVShowListStore()
    
//    var body: some View {
//        List(store.tvShows, id: \.id) { show in
//            HStack {
//
//                VStack {
//                    Text(String(format: "%.1f", show.voteAverage))
//                    Text(String(format: "%d", show.voteCount))
//                }
//                .padding(4)
//                .background(Color.red, in: RoundedRectangle(cornerRadius: 8))
//
//                VStack(alignment: .leading, spacing: 4.0) {
//                    Text(show.name)
//                        .font(.callout)
//                    Text(show.overview)
//                        .font(.footnote)
//                        .foregroundColor(.secondary)
//                }
//
//            }
//
//
//        }
//        .onAppear { store.fetch() }
//    }

    var body: some View {
        NavigationView {
            Group {
                if store.isLoading {
                    Text("Loading...")
                        .foregroundColor(.gray)
                } else {
                    
                    List(store.tvShows, id: \.id) { show in
                        HStack {
                            
                            VStack {
                                Text(String(format: "%.1f", show.voteAverage))
                                Text(String(format: "%d", show.voteCount))
                                    .font(.footnote)
                            }
                            .padding(4)
                            .background(Color.blue, in: RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading, spacing: 4.0) {
                                Text(show.name)
                                    .font(.callout)
                                Text(show.overview)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            
                        }
                        
                        
                    }
                }
            }
            .navigationTitle("Popular TV Shows")
            .onAppear { store.fetch() }
        }
    }
}

struct TVShowList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TVShowList()
                .preferredColorScheme(.dark)
        }
    }
}
