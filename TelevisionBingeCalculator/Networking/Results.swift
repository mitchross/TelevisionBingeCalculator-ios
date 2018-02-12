
//
//  File.swift
//  TelevisionBingeCalculator
//
//  Created by Mitch Ross on 2/6/18.
//  Copyright © 2018 vanillax. All rights reserved.
//

import Foundation

struct Results : Codable {
    let original_name : String?
    let id : Int?
    let name : String?
    let vote_count : Int?
    let vote_average : Double?
    let poster_path : String?
    let first_air_date : String?
    let popularity : Double?
    let genre_ids : [Int]?
    let original_language : String?
    let backdrop_path : String?
    let overview : String?
    let origin_country : [String]?
}
