//
//  TableViewDisplayController.swift
//  Meme_1.0
//
//  Created by Pranay Boggarapu on 8/12/18.
//  Copyright © 2018 Sai Venkata Pranay Boggarapu. All rights reserved.
//

import UIKit

class TableViewDisplayController: UIViewController {

    //MARK: variables declaration
    @IBOutlet var tableView: UITableView!
    
    var preloadedMemes: [Meme]?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: View load and appear functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //initializing the memes
        self.preloadedMemes = appDelegate.memes
        
        
        //Adding the Add(+) button
        let button: UIButton = UIButton(type: UIButtonType.contactAdd)
        button.addTarget(self, action: #selector(navigateToMakeMeme), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        //hiding the nav and tab bar controllers
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.preloadedMemes = appDelegate.memes
        tableView.reloadData()
    }
    
    //MARK: Segue function
    @objc func navigateToMakeMeme() {
        self.performSegue(withIdentifier: "goToMakeMeme", sender: self)
    }
}


