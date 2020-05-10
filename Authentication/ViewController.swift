//
//  ViewController.swift
//  Authentication
//
//  Created by Sanjeev Bharti on 5/10/20.
//  Copyright © 2020 Sanjeev Bharti. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private let viewModel = ViewModel()

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var continueButton: UIButton!

    @IBOutlet var usernameValidationLabel: UILabel!
    @IBOutlet var passwordValidationLabel: UILabel!

    var enableContinueButtonSubscriber: AnyCancellable?
    var usernameValidation: AnyCancellable?
    var passwordValidation: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.isEnabled = true

        usernameValidation = viewModel.usernameValidationPublisher.receive(on: DispatchQueue.main).sink(receiveValue: { validationMessageString in
            self.usernameValidationLabel.text = validationMessageString
        })

        passwordValidation = viewModel.passwordValidationPublisher.receive(on: DispatchQueue.main).sink(receiveValue: { validationMessageString in
            self.passwordValidationLabel.text = validationMessageString
        })

        enableContinueButtonSubscriber = viewModel.enableContinuePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { isValid in
                self.continueButton.isEnabled = isValid
        })
    }


    //MARK:- IBAction

    @IBAction func usernameTextChangeDetectedIn(_ textField: UITextField) {
        viewModel.username = textField.text
    }

    @IBAction func passwordTextChangeDetectedIn(_ textField: UITextField) {
        viewModel.password = textField.text
    }

    @IBAction func confirmPasswordTextChangeDetectedIn(_ textField: UITextField) {
        viewModel.confirmPassword = textField.text
    }

}


