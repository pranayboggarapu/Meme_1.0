//
//  EditAndShareImageControllerExtension.swift
//  Meme_1.0
//
//  Created by Pranay Boggarapu on 8/13/18.
//  Copyright © 2018 Sai Venkata Pranay Boggarapu. All rights reserved.
//

import UIKit

extension EditAndShareImageController: UITextFieldDelegate {
    
    //MARK:- Text field should begin editing function
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //MARK: empty the placeholder
        textField.placeholder = ""
        return true
    }
    
    //MARK:- Text field did begin editing function
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //MARK: empty the placeholder
        textField.placeholder = ""
    }
    
    //MARK:- Text field should return function - function implemented after return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
