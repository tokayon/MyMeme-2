//
//  DetailViewController.swift
//  MyMeme-2
//
//  Created by SergeSinkevych on 31.03.16.
//  Copyright © 2016 Sergii Sinkevych. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme : Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true
        self.imageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
}
