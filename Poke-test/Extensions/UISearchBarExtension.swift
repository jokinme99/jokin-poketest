//
//  UISearchBarExtension.swift
//  Poke-test
//
//  Created by Jokin Egia on 20/12/21.
//

import UIKit
import Zero

extension UISearchBar {
    @IBInspectable var doneAccessory: Bool {
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }
    func addDoneButtonOnKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem =
        UIBarButtonItem(title: ExtensionConstants.doneButtonTitle, style: .done,
                        target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.toolbarPlaceholder = ExtensionConstants.toolbarTitle

        self.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
