//
//  ContributorModel.swift
//  GithubReposSearchApp
//
//  Created by Shri lata Patel on 06/07/24.
//

import Foundation

struct Contributor: Identifiable, Codable {
    let id: Int
    let login: String
    let avatarUrl: String
    let reposUrl: String

    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarUrl = "avatar_url"
        case reposUrl = "repos_url"
    }
}
