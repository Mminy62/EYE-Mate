//
//  Places.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/23.
//

import Foundation

// MARK: - Places
struct Places: Codable {
    let documents: [PlaceList]
}

// MARK: - Document
struct PlaceList: Codable {
    let addressName: String
    let categoryGroupCode: String
    let categoryGroupName: String
    let categoryName: String
    let distance, id, phone, placeName: String
    let placeURL: String
    let roadAddressName, x, y: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
}
