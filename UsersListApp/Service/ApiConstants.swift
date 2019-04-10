//
//  ApiConstants.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 4/10/19.
//  Copyright © 2019 Anatolii Zavialov. All rights reserved.
//

import Foundation

struct API {
    struct kProductionServer {
        static let baseURL = "https://randomuser.me"
        static let api = "/api"
    }
    struct kTestServer {
        static let baseURL = ""
        static let api = "/api"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
