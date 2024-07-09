//
//  RepoModel.swift
//  GithubReposSearchApp
//
//  Created by Shri lata Patel on 06/07/24.
//

import Foundation

struct RepositoryModel: Identifiable, Codable {
    let id: Int
    let name: String
    let fullName: String
    let owner: Owner
    let description: String?
    let htmlUrl: String
    let contributorsUrl: String

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case fullName = "full_name"
        case owner
        case htmlUrl = "html_url"
        case contributorsUrl = "contributors_url"
    }
}

struct Owner: Codable {
    let login: String
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
