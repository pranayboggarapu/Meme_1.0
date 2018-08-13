//
//  TableViewDisplayControllerExtension.swift
//  Meme_1.0
//
//  Created by Pranay Boggarapu on 8/13/18.
//  Copyright © 2018 Sai Venkata Pranay Boggarapu. All rights reserved.
//

import UIKit

 //MARK: - Table view data source
extension TableViewDisplayController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (preloadedMemes?.count)!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = preloadedMemes![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeDisplayCell", for: indexPath) as! MemeTableViewCell
        // Configure the cell...
        cell.memeImage.image = meme.memedImage
        cell.memeText.text = meme.topText+"..."+meme.bottomText
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            viewWillAppear(true)
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "memeDetailViewId") as! MemeDetailViewController
        detailViewController.meme = self.preloadedMemes?[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }

}



