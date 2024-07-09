//
//  GithubService.swift
//  GithubReposSearchApp
//
//  Created by Shri lata Patel on 06/07/24.
//

import Foundation

class GitHubService {
    static let shared = GitHubService()
    private let baseURL = "https://api.github.com"

    func searchRepositories(query: String, page: Int = 1, completion: @escaping (Result<[RepositoryModel], Error>) -> Void) {
        let urlString = "\(baseURL)/search/repositories?q=\(query)&page=\(page)&per_page=10"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                completion(.success(response.items))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func getContributors(urlString: String, completion: @escaping (Result<[Contributor], Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let contributors = try JSONDecoder().decode([Contributor].self, from: data)
                completion(.success(contributors))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct SearchResponse: Codable {
    let items: [RepositoryModel]
}
