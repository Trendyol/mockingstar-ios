//
//  MockingStarURLProtocol.swift
//  
//
//  Created by Yusuf Özgül on 27.11.2023.
//

import Foundation

class MockingStarURLProtocol: URLProtocol {
    private lazy var session: URLSession = { [weak self] in
        URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()

    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else { return false }
        return shouldMockingStarProxy(for: url) && url.host != "localhost" && url.port != MockingStar.shared.defaultPort
    }

    override open class func canInit(with task: URLSessionTask) -> Bool {
        guard let url = task.currentRequest?.url else { return false }
        return shouldMockingStarProxy(for: url) && url.host != "localhost" && url.port != MockingStar.shared.defaultPort
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override open func startLoading() {
        guard let url = request.url else { return }
        guard MockingStarURLProtocol.shouldMockingStarProxy(for: url) else { return session.dataTask(with: request).resume() }

        let mockDomain = ProcessInfo.processInfo.environment["MockingStarDomain", default: ""]
        let shouldNotUseLiveData = ProcessInfo.processInfo.environment["MockingStar_DoNotUseLive"] == "1"
        var mockRequest = URLRequest(url: URL(string: "http://localhost:\(MockingStar.shared.defaultPort)/mock")!)

        mockRequest.httpMethod = "POST"
        mockRequest.addValue(shouldNotUseLiveData ? "true" : "false", forHTTPHeaderField: "disableLiveEnvironment")
        mockRequest.addValue(mockDomain, forHTTPHeaderField: "mockDomain")

        if let deviceId = ProcessInfo.processInfo.environment["DeviceID"] {
            mockRequest.addValue(deviceId, forHTTPHeaderField: "deviceId")
        }

        if let scenario = request.value(forHTTPHeaderField: "MockScenario") ?? MockingStar.shared.scenario(path: request.url?.path, method: request.httpMethod), !scenario.isEmpty {
            mockRequest.addValue(scenario, forHTTPHeaderField: "scenario")
        }

        mockRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let mockRequestBody = MockingStarRequestBody(method: request.httpMethod ?? "",
                                                     url: url,
                                                     header: request.allHTTPHeaderFields,
                                                     body: try? request.httpBodyStream?.readData())

        mockRequest.httpBody = try? JSONEncoder().encode(mockRequestBody)
        session.dataTask(with: mockRequest).resume()
    }

    override open func stopLoading()  {
        session.getTasksWithCompletionHandler { dataTasks, _, _ in
            dataTasks.forEach { $0.cancel() }
        }
    }

    private static func shouldMockingStarProxy(for url: URL) -> Bool {
        let domain: String

#if os(iOS)
        if #available(iOS 16.0, *) {
            domain = url.host() ?? ""
        } else {
            domain = url.host ?? ""
        }
#elseif os(macOS)
        if #available(macOS 13.0, *) {
            domain = url.host() ?? ""
        } else {
            domain = url.host ?? ""
        }
#endif


        let domains = MockingStar.shared.injectedDomains
        guard !domains.isEmpty else { return true }

        var requestDomains: [String] = []

        for index in 0..<domain.components(separatedBy: ".").dropLast().count {
            requestDomains.append(domain.components(separatedBy: ".").dropFirst(index).joined(separator: "."))
        }

        return domains.contains(where: { requestDomains.contains($0) })
    }

}

extension MockingStarURLProtocol: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
        completionHandler(request)
    }

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        client?.urlProtocolDidFinishLoading(self)
    }
}
