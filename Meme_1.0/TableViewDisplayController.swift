//
//  TableViewDisplayController.swift
//  Meme_1.0
//
//  Created by Pranay Boggarapu on 8/12/18.
//  Copyright © 2018 Sai Venkata Pranay Boggarapu. All rights reserved.
//

import UIKit

class TableViewDisplayController: UITableViewController {

    //MARK: variables declaration
    var preloadedMemes: [Meme]?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: View load and appear functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //initializing the memes
        self.preloadedMemes = appDelegate.memes
        //self.navigationController?.navigationBar.topItem?.title = "Sent Memes"
        
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
        //self.navigationController?.navigationBar.topItem?.title = "Sent Memes"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.preloadedMemes = appDelegate.memes
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
        
    }
    
    //MARK: Segue function
    @objc func navigateToMakeMeme() {
        self.performSegue(withIdentifier: "goToMakeMeme", sender: self)
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (preloadedMemes?.count)!
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = preloadedMemes![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeDisplayCell", for: indexPath) as! MemeTableViewCell
        // Configure the cell...
        cell.memeImage.image = meme.memedImage
        cell.memeText.text = meme.topText+"..."+meme.bottomText
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            viewWillAppear(true)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "memeDetailViewId") as! MemeDetailViewController
        detailViewController.meme = self.preloadedMemes?[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
