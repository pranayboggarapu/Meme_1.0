//
//  GridViewDisplayCollectionViewControllerExtension.swift
//  Meme_1.0
//
//  Created by Pranay Boggarapu on 8/13/18.
//  Copyright © 2018 Sai Venkata Pranay Boggarapu. All rights reserved.
//

import UIKit

extension GridViewDisplayControllerCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (preloadedMemes?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = preloadedMemes![indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeGridViewCell", for: indexPath) as! MemeGridViewCellModalCollectionViewCell
        
        // Configure the cell...
        cell.memeImage.image = meme.memedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "memeDetailViewId") as! MemeDetailViewController
        detailViewController.meme = self.preloadedMemes?[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
