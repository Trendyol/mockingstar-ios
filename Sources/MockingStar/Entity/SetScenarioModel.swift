//
//  SetScenarioModel.swift
//
//
//  Created by Yusuf Özgül on 27.11.2023.
//

import Foundation

struct SetScenarioModel: Codable {
    let deviceId: String
    let path: String
    let method: String?
    let scenario: String
    let mockDomain: String
}
