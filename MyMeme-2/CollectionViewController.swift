//
//  CollectionViewController.swift
//  MyMeme-2
//
//  Created by SergeSinkevych on 31.03.16.
//  Copyright © 2016 Sergii Sinkevych. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlowLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
    }
    
    
    // MARK: Collection View Data Source
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        cell.memeImageView?.image = meme.memedImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    //MARK: Setup methods
    
    func setupFlowLayout() {
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2*space))/3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    
    
    
    
    
}
