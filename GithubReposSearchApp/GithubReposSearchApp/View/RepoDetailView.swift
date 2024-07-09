//
//  RepoDetailView.swift
//  GithubReposSearchApp
//
//  Created by Shri lata Patel on 06/07/24.
//

import Foundation
import SwiftUI

struct RepositoryDetailView: View {
    @ObservedObject var viewModel: RepositoryDetailViewModel
    init(repository: RepositoryModel) {
            self.viewModel = RepositoryDetailViewModel(repository: repository)
        }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: viewModel.repository.owner.avatarUrl))
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                Text(viewModel.repository.name)
                    .font(.largeTitle)
                    .padding(.top, 8)
                Text(viewModel.repository.description ?? "No description available")
                    .font(.body)
                    .padding(.top, 4)
                Link("Project Link", destination: URL(string: viewModel.repository.htmlUrl)!)
                    .padding(.top, 8)
                Text("Contributors")
                    .font(.headline)
                    .padding(.top, 16)
                ForEach(viewModel.contributors) { contributor in
                    NavigationLink(destination: ContributorDetailView(contributor: contributor)) {
                        HStack {
                            AsyncImage(url: URL(string: contributor.avatarUrl))
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            Text(contributor.login)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.repository.name)
        .onAppear {
            viewModel.fetchContributors()
        }
    }
}

struct ContributorDetailView: View {
    let contributor: Contributor

    @State private var repositories: [RepositoryModel] = []

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: contributor.avatarUrl))
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            Text(contributor.login)
                .font(.largeTitle)
                .padding(.top, 8)
            List(repositories) { repository in
                RepositoryRow(repository: repository)
            }
        }
        .onAppear {
            fetchRepositories()
        }
    }

    private func fetchRepositories() {
        GitHubService.shared.searchRepositories(query: contributor.reposUrl) { result in
            switch result {
                case .success(let repositories):
                    self.repositories = repositories
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
