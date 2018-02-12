//
//  TheMovieDbClient.swift
//  TelevisionBingeCalculator
//
//  Created by Mitch Ross on 2/6/18.
//  Copyright © 2018 vanillax. All rights reserved.
//

import Foundation

class TheMovieDbClient: APIClient {
    
    static let baseUrl = ""
    static let apiKey = ""
    
    func fetch(with endpoint: TheMovieDbEndpoint, completion:@escaping(Either<TVQueryResponse>) -> Void) {
        
        let request = endpoint.request
         get(with: request, completion: completion)
    }
}
