//
//  MockingStarRequestBody.swift
//
//
//  Created by Yusuf Özgül on 27.11.2023.
//

import Foundation

struct MockingStarRequestBody: Codable {
    let method: String
    let url: URL
    let header: [String: String]?
    let body: Data?
}
