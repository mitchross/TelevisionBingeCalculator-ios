//
//  ViewController.swift
//  Pinterest
//
//  Created by Mitch Ross on 1/1/18.
//  Copyright © 2018 yourcompany. All rights reserved.
//

import UIKit

class ShowsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = ViewModel(client: TheMovieDbClient() )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
//        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
//            layout.delegate = self
//        }
      //  collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        //Init view
        viewModel.showLoading = {
            if self.viewModel.isLoading {
                self.activityIndicator.startAnimating()
                self.collectionView.alpha = 0.0
            } else {
                self.activityIndicator.stopAnimating()
                self.collectionView.alpha = 1.0
            }
        }
        
        viewModel.showError = { error in
            print(error)
        }
        
        viewModel.reloadData = {
            self.collectionView.reloadData()
        }
        
        viewModel.fetchShows()
        
        
        
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

//Mark - Flow layout delegate
//Grid style
//extension ViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let numberOfColumns:CGFloat = 2
//        let width = collectionView.frame.size.width
//        let xInsets: CGFloat = 10
//        let cellSpacing: CGFloat = 5
//        let image = images[indexPath.item]
//        let height = image.size.height
//        return CGSize(width: (width/numberOfColumns) - (xInsets + cellSpacing), height: height)
//    }
//
//}

extension ShowsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var newSize = (collectionView.bounds.size.width - 50) / 3
        
        return CGSize(width: newSize, height: newSize)
    }
    

}
extension ShowsViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = viewModel.showCellViewModels[indexPath.item].image
        let height = image.size.height
        
        return height
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("selected \(indexPath)" )
    }
}

// MARK: Data source

extension ShowsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.showCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell" , for: indexPath) as! ShowCell
        
        let image = viewModel.showCellViewModels[indexPath.item].image
        cell.imageView.image = image
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC: ShowDetailViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController)
        
        let image = viewModel.showCellViewModels[indexPath.item].image
        detailsVC.image = image
        self.navigationController?.pushViewController(detailsVC, animated: true)
        //self.performSegue(withIdentifier: "detailsSegue", sender: self)
    }
    
    
    
}


