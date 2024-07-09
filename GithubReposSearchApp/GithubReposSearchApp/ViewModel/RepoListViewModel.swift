//
//  RepoListViewModel.swift
//  GithubReposSearchApp
//
//  Created by Shri lata Patel on 06/07/24.
//

import Foundation

class RepositoryListViewModel: ObservableObject {
    @Published var repositories: [RepositoryModel] = []
    @Published var page = 1
    @Published var query = ""

    private var isLoading = false

    func searchRepositories() {
        guard !query.isEmpty else { return }
        isLoading = true
        GitHubService.shared.searchRepositories(query: query, page: page) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let repositories):
                    if self.page == 1 {
                        self.repositories = repositories
                    } else {
                        self.repositories.append(contentsOf: repositories)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func loadMore() {
        guard !isLoading else { return }
        page += 1
        searchRepositories()
    }

    func resetSearch() {
        repositories = []
        page = 1
    }
}
