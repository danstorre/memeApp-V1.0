//
//  DefaultTextField.swift
//  MemeMe 1.0
//
//  Created by Daniel Torres on 9/19/16.
//  Copyright © 2016 Danieltorres. All rights reserved.
//

import UIKit

class DefaultTextField: UITextField {

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let memeTextAttributes = [
             NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
             NSStrokeWidthAttributeName : NSNumber(value: -3 as Float),
             NSStrokeColorAttributeName : UIColor.black,
             NSForegroundColorAttributeName : UIColor.white
        ]
        
        defaultTextAttributes = memeTextAttributes
        
        textAlignment = .center
    }
    
    
    
}
