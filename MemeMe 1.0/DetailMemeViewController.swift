//
//  DetailMemeViewController.swift
//  MemeMe 1.0
//
//  Created by Daniel Torres on 10/10/16.
//  Copyright © 2016 Danieltorres. All rights reserved.
//

import UIKit

class DetailMemeViewController: UIViewController {

    @IBOutlet weak var imageMeme: UIImageView!
    
    var memeSelected : Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meme = memeSelected {
            imageMeme.image = meme.memeImage
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
