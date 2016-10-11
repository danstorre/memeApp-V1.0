//
//  SentMemesCollectionViewController.swift
//  MemeMe 1.0
//
//  Created by Daniel Torres on 10/5/16.
//  Copyright © 2016 Danieltorres. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    var selectedMeme : Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 3
        let width = (view.frame.size.width - (2 * space)) / 3.0
        
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: 95)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addAMeme(_ sender: AnyObject) {
        let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        let defaultMeme = Meme()
        
        memeEditorVC.aMeme = defaultMeme
        
        self.present(memeEditorVC, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Set image meme
        cell.cellMemeImage.image = meme.memeImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedMeme = memes[indexPath.row]
        self.performSegue(withIdentifier: "detailMeme", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailMeme" {
            
            let memeEditorVC = segue.destination as! DetailMemeViewController
            
            memeEditorVC.memeSelected = selectedMeme
        }
    }
    

}
