//
//  MemeDetailViewController.swift
//  Exper
//
//  Created by Brittany Mason on 9/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//


import UIKit
import Foundation

// MARK: - MemeDetailViewController: UIViewController

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties

    
    var memes: FullMeme!
//    let chi = self.memes[(IndexPath as NSIndexPath).row]
    // MARK: Outlets
    
    @IBOutlet weak var memeImageDetailView: UIImageView!

    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memeImageDetailView!.image = memes.memedImage
        self.tabBarController?.tabBar.isHidden = true
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
}


