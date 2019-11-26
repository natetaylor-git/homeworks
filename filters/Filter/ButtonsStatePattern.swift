//
//  ButtonsStatePattern.swift
//  Filter
//
//  Created by nate.taylor_macbook on 26/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class ButtonsContext {
    private lazy var state: ButtonStateProtocol = ButtonStateUnlocked(context: self)

    private let buttons: [UIButton]
    
    init(galleryButton: UIButton, cameraButton: UIButton) {
        self.buttons = [galleryButton, cameraButton]
    }
    
    func changeState(_ state: ButtonStateProtocol) {
        self.state = state
    }
    
    func setupActivity() {
        self.state.setupActivity()
    }
    
    func configureButtons() {
        for button in self.buttons {
            button.isEnabled = self.state.active
            button.alpha = self.state.alpha
        }
    }
}

protocol ButtonStateProtocol {
    var active: Bool{ get }
    var alpha: CGFloat { get }
    func setupActivity()
}

class ButtonStateLocked: ButtonStateProtocol {
    fileprivate weak var context: ButtonsContext?
    var active: Bool
    var alpha: CGFloat
    
    init(context: ButtonsContext) {
        self.context = context
        self.active = false
        self.alpha = 0.5
    }
    
    func setupActivity() {
        self.context?.changeState(ButtonStateUnlocked(context: self.context!))
        UIView.animate(withDuration: 1.0) {
            self.context?.configureButtons()
        }
    }
}

class ButtonStateUnlocked: ButtonStateProtocol {
    fileprivate weak var context: ButtonsContext?
    var active: Bool
    var alpha: CGFloat
    
    init(context: ButtonsContext) {
        self.context = context
        self.active = true
        self.alpha = 1.0
    }
    
    func setupActivity () {
        self.context?.changeState(ButtonStateLocked(context: self.context!))
        self.context?.configureButtons()
    }
}

