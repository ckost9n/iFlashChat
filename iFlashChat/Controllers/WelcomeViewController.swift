//
//  WelcomeViewController.swift
//  iFlashChat
//
//  Created by Konstantin on 20.04.2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationText()
        
    }
    
    private func animationText() {
        titleLabel.text = ""
        let titleText = "⚡️FlashChat"
        
        for letter in titleText.enumerated() {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(letter.offset), repeats: false) { timer in
                self.titleLabel.text! += String(letter.element)
            }
            
        }
    }


}

