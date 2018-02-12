//
//  Endpoint.swift
//  TelevisionBingeCalculator
//
//  Created by Mitch Ross on 2/6/18.
//  Copyright © 2018 vanillax. All rights reserved.
//

import Foundation

protocol Endpoint {
    
    var baseUrl: String {get}
    var path: String {get}
    var urlParameters: [URLQueryItem] {get}
    
}

extension Endpoint {
    
    var urlComponent: URLComponents {
        var urlComponent = URLComponents(string: baseUrl)
        urlComponent?.path = path
        urlComponent?.queryItems = urlParameters
        return urlComponent!
    }
    
    var request: URLRequest {
        return URLRequest(url: urlComponent.url!)
    }
    

}

enum ShowContentType: String {
    case tv,movie
}

enum TheMovieDbEndpoint: Endpoint {
    
    case searchTV(showQuery: String)
    
    
    var baseUrl: String {
        return "http://api.themoviedb.org"
    }
    
    
    var path: String {
        switch self {
        case .searchTV:
            return "/3/search/tv"
        default:
            return "/3/search/tv"
        }
    }
    
    var urlParameters: [URLQueryItem] {
        switch self {
        case .searchTV(let showQuery):
            return [
                URLQueryItem(name:"api_key", value: "1e4890cd4f30dab070baf9672def4f17"),
                URLQueryItem(name:"query", value: showQuery)
            ]
        }
    }
    
}
