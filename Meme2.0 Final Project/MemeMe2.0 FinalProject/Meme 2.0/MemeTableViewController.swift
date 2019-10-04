//
//  Sent Memes Table .swift
//  Exper
//
//  Created by Brittany Mason on 9/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ViewController: UIViewController, UITableViewDataSource
//class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
class MemeTableViewController: UITableViewController
{
   
    @IBOutlet var tableViewImage: UITableView!


    let cellReuseIdentifier = "previousSentMemes"

    // Choose some data to show in your table
    
    var memes: [FullMeme]!
    {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableViewImage.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier)!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText
        
        return cell

        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.memes = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    
}

