//
//  PostCellConfigurable.swift
//  Reddit
//
//  Created by Folarin Williamson on 10/10/20.
//

import Foundation

// MARK: PostCellConfigurable
protocol PostCellConfigurable {
    var title: String { get }
    var subtitle: String { get }
}

// MARK: RedditPostCellViewModel
struct RedditPostCellViewModel: PostCellConfigurable {
    let title: String
    let subtitle: String
}
