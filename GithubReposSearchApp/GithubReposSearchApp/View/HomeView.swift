//
//  HomeView.swift
//  GithubReposSearchApp
//
//  Created by Shri lata Patel on 06/07/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = RepositoryListViewModel()
    

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.query, onSearchButtonClicked: {
                    viewModel.resetSearch()
                    viewModel.searchRepositories()
                })
                List(viewModel.repositories) { repository in
                    NavigationLink(destination: RepositoryDetailView(repository: repository)) {
                        RepositoryRow(repository: repository)
                    }
                }
                if !viewModel.repositories.isEmpty {
                    Button("Load More") {
                        viewModel.loadMore()
                    }
                }
            }
            .navigationTitle("GitHub Repos")
        }
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var onSearchButtonClicked: () -> Void

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        var onSearchButtonClicked: () -> Void

        init(text: Binding<String>, onSearchButtonClicked: @escaping () -> Void) {
            _text = text
            self.onSearchButtonClicked = onSearchButtonClicked
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            onSearchButtonClicked()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, onSearchButtonClicked: onSearchButtonClicked)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

struct RepositoryRow: View {
    let repository: RepositoryModel

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: repository.owner.avatarUrl))
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(repository.name)
                    .font(.headline)
                Text(repository.owner.login)
                    .font(.subheadline)
            }
        }
    }
}
