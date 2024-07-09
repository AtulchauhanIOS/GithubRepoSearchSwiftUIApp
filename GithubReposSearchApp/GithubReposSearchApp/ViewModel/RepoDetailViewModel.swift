//
//  RepoDetailViewModel.swift
//  GithubReposSearchApp
//
//  Created by Shri lata Patel on 06/07/24.
//

import Foundation

class RepositoryDetailViewModel: ObservableObject {
    @Published var repository: RepositoryModel
    @Published var contributors: [Contributor] = []

    init(repository: RepositoryModel) {
        self.repository = repository
        fetchContributors()
    }

    func fetchContributors() {
        GitHubService.shared.getContributors(urlString: repository.contributorsUrl) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let contributors):
                    self.contributors = contributors
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

