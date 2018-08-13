//
//  GridViewDisplayControllerCollectionViewController.swift
//  Meme_1.0
//
//  Created by Pranay Boggarapu on 8/12/18.
//  Copyright © 2018 Sai Venkata Pranay Boggarapu. All rights reserved.
//

import UIKit


class GridViewDisplayControllerCollectionViewController: UIViewController {

    //MARK: Variables and outlet declaration
    var preloadedMemes: [Meme]?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    //MARK: View Did load and appear functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializing the memes
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
        self.preloadedMemes = appDelegate.memes
        collectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: Set constraints method
    func setConstraints() {
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / space
        
        collectionFlowLayout.minimumInteritemSpacing = space
        collectionFlowLayout.minimumLineSpacing = space
        collectionFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    //MARK: Segue function to navigate to meme edit
    @objc func navigateToMakeMeme() {
        self.performSegue(withIdentifier: "goToMakeMeme_ViaGrid", sender: self)
    }

    
}
