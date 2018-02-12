//
//  File.swift
//  TelevisionBingeCalculator
//
//  Created by Mitch Ross on 2/11/18.
//  Copyright © 2018 vanillax. All rights reserved.
//

import UIKit

struct ShowCellViewModel{
    let image: UIImage
}

class ViewModel {
    
    private let client: APIClient
    

    private var tvQueryResponse: TVQueryResponse = TVQueryResponse() {
        didSet {
            self.fetchShow()
        }
    }
    
    var showCellViewModels: [ShowCellViewModel] = []
    
    var isLoading: Bool = false {
        didSet {
            showLoading?()
        }
    }
    
    var showLoading: (() -> Void)?
    var reloadData: (() ->Void)?
    var showError: ( (Error)->Void)?
    
    init(client: APIClient) {
        self.client = client
    }

    
    func fetchShows() {
        
        if let client = client as? TheMovieDbClient {
            self.isLoading = true
            let endpoint = TheMovieDbEndpoint.searchTV(showQuery: "lost")
            
            client.fetch(with: endpoint, completion: { (either) in
                switch either {
                case .success(let tvQueryResponse):
                    self.tvQueryResponse = tvQueryResponse
                case .error(let error):
                    self.showError?(error)
                }
                
            })
        }
        
    }
    
    private func fetchShow() {
        
        let group = DispatchGroup()
        var count = 0;
        
        self.tvQueryResponse.results?.forEach { (result) in
            DispatchQueue.global(qos: .background).async(group: group) {
                group.enter()
                if( count >= 7)
                {
                    group.leave()
                }
                count = count + 1
              
                
                guard let posterPath = result.poster_path else {
                    return
                }
                
                let fullPosterUrl = self.getPosterURL(posterImageEndpoint: posterPath)
                
                guard let posterPathURL = URL(string: fullPosterUrl) else {
                    return
                }
                
                
                guard let imageData = try? Data(contentsOf: posterPathURL) else {
                    self.showError?(APIerror.imageDownload)
                    return
                }
                
                guard let image = UIImage(data: imageData) else {
                    self.showError?(APIerror.imageConvert)
                    return
                }
                
                
                self.showCellViewModels.append(ShowCellViewModel(image: image))
                

                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isLoading = false
            self.reloadData?()
        }
        
    }
    
    func getPosterURL(posterImageEndpoint: String) -> String {
        var basePosterURL: String = "http://image.tmdb.org/t/p/w500"
        return basePosterURL + posterImageEndpoint
    }
}
