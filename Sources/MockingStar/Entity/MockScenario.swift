//
//  MockScenario.swift
//
//
//  Created by Yusuf Özgül on 27.11.2023.
//

import Foundation

public struct MockScenario {
    let path: String
    let scenario: String
    let method: String

    public init(path: String, scenario: String, method: String = "GET") {
        self.path = path
        self.scenario = scenario
        self.method = method
    }
}
