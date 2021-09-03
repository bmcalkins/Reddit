//
//  Posts.swift
//  Reddit
//
//  Created by Folarin Williamson on 10/10/20.
//

import Foundation

struct Post: Decodable {
    let subreddit: String
    let title: String
    let url: String
}
