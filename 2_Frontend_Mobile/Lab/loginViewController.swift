//
//  loginViewController.swift
//  Lab
//
//  Created by Alvaro Landaluce on 11/17/16.
//  Copyright © 2016 Alvaro Landaluce. All rights reserved.
//

import UIKit

@IBDesignable class LoginView: UIView {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
}
