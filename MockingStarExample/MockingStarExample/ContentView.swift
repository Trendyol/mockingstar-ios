//
//  ContentView.swift
//  MockingStarExample
//
//  Created by Yusuf Özgül on 27.11.2023.
//

import SwiftUI
import MockingStar

struct ContentView: View {
    @State private var searchTerm: String = ""
    @State private var results: [SearchResultItem] = []
    @State private var isLoading: Bool = false
    @State private var isSearchResultEmpty: Bool = false
    @State private var shouldShowError = false
    @State private var errorMessage: String = ""
    @State private var mockingStarEnabled = false

    var body: some View {
        NavigationStack {
            if isSearchResultEmpty {
                ContentUnavailableView
                    .search(text: searchTerm)
                    .accessibilityIdentifier("ContentUnavailableView")
            }

            List(results) { repo in
                VStack(alignment: .leading, spacing: 6) {
                    Text(repo.fullName)
                        .font(.title3)
                        .accessibilityIdentifier("FullName")

                    Text("\(Image(systemName: "tuningfork")) \(repo.forksCount)  -  \(Image(systemName: "star.fill")) \(repo.stargazersCount)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier("StarForkCount")

                    if let description = repo.description {
                        Text(description)
                            .font(.caption2)
                            .accessibilityIdentifier("Description")
                    }
                }
            }
            .accessibilityIdentifier("List")
            .overlay { if isLoading { ProgressView() }}
            .searchable(text: $searchTerm)
            .onSubmit(of: .search) {
                search()
            }
            .navigationTitle("Github Search")
            .alert("Error", isPresented: $shouldShowError) {} message: {
                Text(errorMessage)
            }
            .toolbar {
                ToolbarItem {
                    if ProcessInfo.processInfo.environment["EnableMockingStar"] != "1" && !mockingStarEnabled {
                        Button("Enable MockingStar") {
                            MockingStar.shared.inject()
                            mockingStarEnabled = true
                        }
                    }
                }
            }
        }
        .accessibilityIdentifier("NavigationStack")
    }

    func search() {
        isLoading = true
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(searchTerm)") else { return }

        Task { @MainActor in
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let res = response as? HTTPURLResponse, res.statusCode != 200 {
                    throw NSError(domain: "Failed", code: res.statusCode)
                }

                results = try JSONDecoder().decode(SearchResultModel.self, from: data).items
                isSearchResultEmpty = results.isEmpty
            } catch {
                errorMessage = "Network error"
                shouldShowError = true
            }
            isLoading = false
        }
    }
}

#Preview {
    ContentView()
}

struct SearchResultModel: Codable {
    let items: [SearchResultItem]
}

struct SearchResultItem: Codable, Identifiable {
    let id: Int
    let fullName: String
    let description: String?
    let forksCount: Int
    let stargazersCount: Int

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case description, id
    }
}
