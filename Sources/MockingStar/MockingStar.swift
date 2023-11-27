//
//  MockingStar.swift
//  
//
//  Created by Yusuf Özgül on 27.11.2023.
//

import Foundation

public final class MockingStar {
    public static let shared: MockingStar = .init()
    public var defaultPort: Int = 8008
    private var mockScenarios: [MockScenario] = []

    private init() {
        URLProtocol.registerClass(MockingStarURLProtocol.self)
    }

    public func inject(configuration: URLSessionConfiguration) {
        configuration.protocolClasses?.insert(MockingStarURLProtocol.self, at: .zero)
    }

    public func inject() {
        URLSessionConfiguration.default.protocolClasses?.insert(MockingStarURLProtocol.self, at: .zero)
    }

    public func insertMockState(_ mockState: MockScenario) {
        mockScenarios.append(mockState)
    }

    func scenario(path: String?, method: String?) -> String? {
        guard let scenario = mockScenarios.first(where: { $0.path == path && $0.method == method })?.scenario else { return nil }
        mockScenarios.removeAll(where: { $0.path == path && $0.method == method })
        return scenario
    }

    public func addScenario(path: String, scenario: String, method: String) {
        mockScenarios.append(.init(path: path, scenario: scenario, method: method))
    }
}
