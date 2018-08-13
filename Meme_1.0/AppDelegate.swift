//
//  AppDelegate.swift
//  Meme_1.0
//
//  Created by Sai Venkata Pranay Boggarapu on 7/12/18.
//  Copyright © 2018 Sai Venkata Pranay Boggarapu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: Variables Declaration
    var window: UIWindow?
    var memes = [Meme]()
    
    //MARK: Functions calling
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.getInitialMemes()
        return true
    }
    
    //to return list of prefed memees
    func getInitialMemes() -> [Meme]  {
        let memes = [Meme(topText: "DONT STARE AT ME", bottomText: "I MYT END UP BITING U", originalImage:     UIImage(named: "dogImage_Original")!, memedImage: UIImage(named: "dogImage")!),
                     Meme(topText: "PRESS UR ZIP CODE", bottomText: "ILL TAKE U TO HOME", originalImage:
                        UIImage(named: "carImage_Original")!, memedImage: UIImage(named: "carImage")!),
                     Meme(topText: "SO CUTE", bottomText: "JUST LIKE AN ANGEL", originalImage: UIImage(named: "babyImage_Original")!, memedImage: UIImage(named: "babyImage")!),
                     Meme(topText: "BEST BAND SO FAR", bottomText: "", originalImage: UIImage(named: "popImage_Original")!, memedImage: UIImage(named: "popImage")!),
                    Meme(topText: "REALITY OF SOFTWARE", bottomText: "EXAMPLE IS OUR OFFICE", originalImage: UIImage(named: "softwareImage_Original")!, memedImage: UIImage(named: "softwareImage")!)]
        
        return memes
    }
}

