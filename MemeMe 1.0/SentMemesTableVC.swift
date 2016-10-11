//
//  SentMemesTableVC.swift
//  MemeMe 1.0
//
//  Created by Daniel Torres on 10/5/16.
//  Copyright © 2016 Danieltorres. All rights reserved.
//

import UIKit

class SentMemesTableVC: UITableViewController {

    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    var selectedMeme : Meme?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath)
        let meme = self.memes[indexPath.row]
        
        // Set image meme
        cell.textLabel?.text = "\(meme.topText) ... \(meme.bottomText)"
        cell.imageView?.image = meme.memeImage
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
