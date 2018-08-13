//
//  MemeDetailViewController.swift
//  Meme_1.0
//
//  Created by Pranay Boggarapu on 8/13/18.
//  Copyright © 2018 Sai Venkata Pranay Boggarapu. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme?.memedImage
    }

}
