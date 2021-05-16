//
//  UserViewModel.swift
//  Swift-Notion-API-Integration-Sample
//
//  Created by Gerson Janhuel on 15/05/21.
//

import Foundation
import Combine


enum NotionAPIError: Error, Identifiable {
    case serverError
    case noData
    
    var id: Self {
        self
    }
}


class UserViewModel: ObservableObject {
    
    @Published var users: [NotionDatabaseRowUserObject] = []
    @Published var database: NotionDatabase?
    
    
    private var cancellable: AnyCancellable?
    private let urlSession = URLSession(configuration: .default)
    private let baseURL = "https://api.notion.com/v1/databases"
    private let databaseId = "9026ab4729d54640835bfd4b1c9deee4"
    private let accessToken = "secret_aLg5owjTnx31e0GUUyQBKCRRWqK5vw6o71ji0E89HAy"
}

extension UserViewModel {
    // query database rows
    // https://developers.notion.com/reference/post-database-query
    
    func queryFromDatabase() {
        
        let urlString = baseURL + "/" + databaseId + "/query"
        guard let apiURL = URL(string: urlString) else { return }
        var apiURLRequest = URLRequest(url: apiURL)
        
        apiURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        apiURLRequest.addValue("2021-05-13", forHTTPHeaderField: "Notion-Version")
        apiURLRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        apiURLRequest.httpMethod = "POST"
        
        // sorting with plain text
        // more on https://developers.notion.com/reference/post-database-query#post-database-query-sort
        
        apiURLRequest.httpBody = """
            {
                "sorts": [
                    {
                        "property": "Name",
                        "direction": "ascending"
                    }
                ]
            }
            """.data(using: .utf8)
        
        // combine framework
        cancellable = urlSession
            .dataTaskPublisher(for: apiURLRequest)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw NotionAPIError.serverError
                }
                return output.data
            }
            .decode(type: NotionDatabaseQueryResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (subscriber) in

                    switch subscriber {
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    case .finished:
                        break
                    }

                },
                receiveValue: { [weak self] database in
                    guard let self = self else { return }
                    self.users = database.results
                }
            )   
    }
    
    // Retrieve A Database
    // https://developers.notion.com/reference/get-database
    
    func retrieveDatabaseInfo() {
        let urlString = baseURL + "/" + databaseId
        guard let apiURL = URL(string: urlString) else { return }
        var apiURLRequest = URLRequest(url: apiURL)
        
        apiURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        apiURLRequest.addValue("2021-05-13", forHTTPHeaderField: "Notion-Version")
        apiURLRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        apiURLRequest.httpMethod = "GET"
        
        // combine framework
        cancellable = urlSession
            .dataTaskPublisher(for: apiURLRequest)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw NotionAPIError.serverError
                }
                return output.data
            }
            .decode(type: NotionDatabase.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (subscriber) in

                    switch subscriber {
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    case .finished:
                        break
                    }

                },
                receiveValue: { [weak self] database in
                    print(database)
                    
                    guard let self = self else { return }
                    self.database = database
                }
            )
    }
}



