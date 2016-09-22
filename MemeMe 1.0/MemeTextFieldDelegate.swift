//
//  MemeTextFieldDelegate.swift
//  MemeMe 1.0
//
//  Created by Daniel Torres on 9/19/16.
//  Copyright © 2016 Danieltorres. All rights reserved.
//

import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    

}


