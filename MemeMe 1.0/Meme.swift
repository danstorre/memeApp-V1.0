//
//  Meme.swift
//  MemeMe 1.0
//
//  Created by Daniel Torres on 9/21/16.
//  Copyright © 2016 Danieltorres. All rights reserved.
//

import UIKit

struct Meme {

    let topText : String
    let bottomText : String
    let originalImage : UIImage?
    let memeImage : UIImage?
    
    init(){
        topText = "TOP"
        bottomText = "BOTTOM"
        originalImage = UIImage()
        memeImage = UIImage()
    }
    
    init(topText : String, bottomText : String, originalImage : UIImage, memeImage : UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memeImage = memeImage
    }
    
}
