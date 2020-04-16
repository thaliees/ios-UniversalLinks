//
//  ItemModel.swift
//  UniversalLinks
//
//  Created by Thaliees on 4/15/20.
//  Copyright © 2020 Thaliees. All rights reserved.
//

import Foundation

// MARK: - ItemModel
struct ItemModel: Codable {
    let products: [Product]
}

// MARK: - Product
struct Product: Codable {
    let id, name, image, storeID: String
    let storeName, lastModification: String
    let characteristics: Characteristics

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, image
        case storeID = "storeId"
        case storeName, lastModification, characteristics
    }
}

// MARK: - Characteristics
struct Characteristics: Codable {
    let characteristicsDescription, size, volAlch, color: String

    enum CodingKeys: String, CodingKey {
        case characteristicsDescription = "description"
        case size, volAlch, color
    }
}

// MARK: - RefreshTokenModel
struct RefreshTokenModel: Codable {
    let token: String
}

// MARK: - ErrorModel
struct ErrorModel: Codable {
    let code: Int
    let message: String
}

