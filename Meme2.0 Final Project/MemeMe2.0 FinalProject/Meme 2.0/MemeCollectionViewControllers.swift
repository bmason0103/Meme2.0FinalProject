//
//  MemeCollectionViewControllers.swift
//  Exper
//
//  Created by Brittany Mason on 9/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewControllers: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout?
   
    var memes: [FullMeme]!
    {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
        self.tabBarController?.tabBar.isHidden = false
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let width = (view.frame.size.width - (5 * space)) / 3.0
        let height = (view.frame.size.height - (5 * space)) / 3.0
        
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.minimumLineSpacing = space
        flowLayout?.itemSize = CGSize(width: width , height: height)
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath) as! CollectionViewCell
//       PREVIOUS CODE  let meme = memes[(indexPath as NSIndexPath).row]
        let meme = memes[indexPath.row]
        
        cell.memeCollectionViewImage?.image = meme.memedImage
        cell.memeLabel?.text = memes[indexPath.row].topText + "..." + memes[indexPath.row].bottomText
        
        return cell
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {

        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController

        
        detailController.memes = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    
    }
    
    
}


