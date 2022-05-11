//
//  ContentView.swift
//  MovieDB
//
//  Created by Alex on 19.04.2022.
//

import SwiftUI
import Combine

class TVShowListViewModel: ObservableObject {
    
    @Published private(set) var tvShows: [TVShow] = []
    @Published private(set) var isLoading: Bool = false
    
    private let mock: [TVShow] = [
        TVShow(id: 1, name: "Test Name 1", originalName: "", overview: "Over\nview", firstAirDate: Date(), genreIds: [], posterPath: "", backdropPath: "", popularity: 9, voteAverage: 9, voteCount: 10),
        TVShow(id: 2, name: "Test Name 2", originalName: "", overview: "Overview", firstAirDate: Date(), genreIds: [], posterPath: "", backdropPath: "", popularity: 9, voteAverage: 9, voteCount: 10),
        TVShow(id: 3, name: "Test Name 3", originalName: "", overview: "Overview", firstAirDate: Date(), genreIds: [], posterPath: "", backdropPath: "", popularity: 9, voteAverage: 9, voteCount: 10)
    ]

    private var subscriptions: Set<AnyCancellable> = []

    func fetch() {
        tvShows = mock
        return
        
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

    @ObservedObject var store = TVShowListViewModel()

    var body: some View {
        ShowsList(store: store)
//        NavigationView {
//            Group {
//                ShowsList(store: store)
//            }
//            .navigationTitle("Popular TV Shows")
//        }
        .onAppear { store.fetch() }
    }
}

struct ShowsList: View {
    
    @ObservedObject var store: TVShowListViewModel
    
    var body: some View {
        List(store.tvShows, id: \.id) { show in
            HStack {
                
                Rectangle()
                    .background(.gray)
                    .frame(width: 100, height: 160)
                
                VStack(alignment: .leading, spacing: 4.0) {

                    Text(show.name)
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text(show.firstAirDate, format: Date.FormatStyle().year().month().day())
                        .font(.system(size: 12))
                        .foregroundColor(.teal)

                    Text(show.overview)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    
                    
                    VStack {
                        Text(String(format: "%.3f", show.popularity))
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .frame(width: 60, height: 20)
                    .background(Color.green, in: RoundedRectangle(cornerRadius: 8))
                    
                    VStack {
                        Text(String(format: "%.1f", show.voteAverage))
                            .font(.system(size: 12, weight: .semibold))
                        Text(String(format: "%d", show.voteCount))
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundColor(Color.secondary)
                    }
                    .frame(width: 30, height: 30)
                    .background(Color.blue, in: RoundedRectangle(cornerRadius: 8))
                    
                }
                
                
                
            }
        }.onHover { print("hello \($0)") }
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
