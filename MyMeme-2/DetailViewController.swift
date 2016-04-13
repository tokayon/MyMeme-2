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
    var editButton : UIBarButtonItem!
    var saveButton : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editMeme")
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = true
        imageView.image = meme.memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
    
    func editMeme() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        memeEditorVC.inputMeme = meme
        self.presentViewController(memeEditorVC, animated: true, completion: nil)
    }
}
