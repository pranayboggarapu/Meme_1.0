//
//  GridViewDisplayControllerCollectionViewController.swift
//  Meme_1.0
//
//  Created by Pranay Boggarapu on 8/12/18.
//  Copyright © 2018 Sai Venkata Pranay Boggarapu. All rights reserved.
//

import UIKit


class GridViewDisplayControllerCollectionViewController: UICollectionViewController {

    //MARK: Variables and outlet declaration
    var preloadedMemes: [Meme]?
    
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    //MARK: View Did load and appear functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializing the memes
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.preloadedMemes = appDelegate.memes
        
        //adding the (+) button
        let button: UIButton = UIButton(type: UIButtonType.contactAdd)
        button.addTarget(self, action: #selector(navigateToMakeMeme), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        //hiding the nav and tab bars
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        //set the constraints
        setConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.preloadedMemes = appDelegate.memes
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        collectionView?.reloadData()
    }
    
    //MARK: Set constraints method
    func setConstraints() {
        
        let space:CGFloat = 2.0
        let dimension = (view.frame.size.width - (2 * space)) / 5.0
        
        collectionFlowLayout.minimumInteritemSpacing = space
        collectionFlowLayout.minimumLineSpacing = space
        collectionFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    //MARK: Segue function to navigate to meme edit
    @objc func navigateToMakeMeme() {
        self.performSegue(withIdentifier: "goToMakeMeme_ViaGrid", sender: self)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (preloadedMemes?.count)!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = preloadedMemes![indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeGridViewCell", for: indexPath) as! MemeGridViewCellModalCollectionViewCell
    
        // Configure the cell...
        cell.memeImage.image = meme.memedImage
        return cell
    }

    

}
