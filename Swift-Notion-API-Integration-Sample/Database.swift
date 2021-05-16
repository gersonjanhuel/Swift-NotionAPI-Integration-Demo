//
//  Database.swift
//  Swift-Notion-API-Integration-Sample
//
//  Created by Gerson Janhuel on 15/05/21.
//

import Foundation

struct NotionDatabase: Decodable, Identifiable {
    let object: String
    let id: String
    let created_time: String
    
    // more properties at https://developers.notion.com/reference-link/database
}

struct NotionDatabaseQueryResponse: Decodable {
    let object: String
    let results: [NotionDatabaseRowUserObject]
}

struct NotionDatabaseRowUserObject: Decodable, Identifiable {
    let id: String
    let created_time: String
    let last_edited_time: String
    let properties: UserProperties
}

struct UserProperties: Decodable {
    let Email: EmailObject
    let Name: NameObject
}

struct NameObject: Decodable {
    let title: [PlainText]
}

struct EmailObject: Decodable {
    let rich_text: [PlainText]
}


struct PlainText: Decodable {
    let plain_text: String
}


