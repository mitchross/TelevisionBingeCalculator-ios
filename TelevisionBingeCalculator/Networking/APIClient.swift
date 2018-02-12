//
//  File.swift
//  TelevisionBingeCalculator
//
//  Created by Mitch Ross on 2/4/18.
//  Copyright © 2018 vanillax. All rights reserved.
//

import Foundation

enum Either<T> {
    case success(T)
    case error(Error)
}

enum APIerror: Error {
    case unknown, badResponse, jsonDecoder, imageDownload,imageConvert
}

protocol APIClient {
    var session: URLSession { get }
    func  get<T:Codable>(with request: URLRequest, completion: @escaping(Either<T>) -> Void )
    
    
    
}

extension APIClient {
    var session: URLSession {
        return URLSession.shared
    }
    
    
    func  get<T:Codable>(with request: URLRequest, completion: @escaping(Either<T>) -> Void ) {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                completion(.error(error!))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                completion(.error(APIerror.badResponse))
                print("Error: with response")
                return
            }
            
            var datatest = data;
            
            guard let value = try? JSONDecoder().decode(T.self, from: data!) else {
                print("Decoder error")
                completion(.error(APIerror.jsonDecoder))
                
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(value))
                
            }
            
        }
        task.resume()
        
    }
    
}

