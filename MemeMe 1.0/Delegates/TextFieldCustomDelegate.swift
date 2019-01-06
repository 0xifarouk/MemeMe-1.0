//
//  TextFieldCustomDelegate.swift
//  MemeMe 1.0
//
//  Created by FarouK on 26/10/2018.
//  Copyright © 2018 FarouK. All rights reserved.
//

import Foundation
import UIKit

class TextFieldCustomDelegate: NSObject, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //capitalizing all letters in textField
        textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
        return false
       
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
