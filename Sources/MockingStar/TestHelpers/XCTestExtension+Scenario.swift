//
//  XCTestExtension+Scenario.swift
//
//
//  Created by Yusuf Özgül on 27.11.2023.
//

import Foundation

public protocol BaseMockXCTest {
    var deviceId: String { get }
    var mockDomain: String { get }

    func setScenario(path: String, method: MockServerHTTPMethod, scenario: String) async throws
    func removeScenarios() async throws
}

public enum MockServerHTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

public extension BaseMockXCTest {
    func setScenario(path: String, method: MockServerHTTPMethod, scenario: String) async throws {
        guard let url = URL(string: "http://localhost:\(MockingStar.shared.defaultPort)/scenario") else { preconditionFailure("URL Error") }
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = SetScenarioModel(deviceId: deviceId,
                                    path: path,
                                    method: method.rawValue,
                                    scenario: scenario, 
                                    mockDomain: mockDomain)
        req.httpBody = try JSONEncoder().encode(body)

        let (_, response) = try await URLSession.shared.data(for: req)
        guard let response = response as? HTTPURLResponse, response.statusCode == 202 else {
            throw createError(message: "Set scenario error")
        }
    }

    func removeScenarios() async throws {
        guard let url = URL(string: "http://localhost:\(MockingStar.shared.defaultPort)/scenario") else { preconditionFailure("URL Error") }
        var req = URLRequest(url: url)
        req.httpMethod = "DELETE"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = SetScenarioModel(deviceId: deviceId,
                                    path: "",
                                    method: "",
                                    scenario: "", 
                                    mockDomain: mockDomain)
        req.httpBody = try JSONEncoder().encode(body)

        let (_, response) = try await URLSession.shared.data(for: req)
        guard let response = response as? HTTPURLResponse, response.statusCode == 202 else {
            throw createError(message: "Remove scenario error")
        }
    }
}
