//
//  ViewModel.swift
//  Authentication
//
//  Created by Sanjeev Bharti on 5/10/20.
//  Copyright © 2020 Sanjeev Bharti. All rights reserved.
//

import Foundation
import Combine

class ViewModel {

    @Published var username: String?
    @Published var password: String?
    @Published var confirmPassword: String?

    // on demand publishers
    let usernameValidationPublisher = PassthroughSubject<String?, Never>()
    let passwordValidationPublisher = PassthroughSubject<String?, Never>()

    // on update publisher
    var usernamePublisher: AnyPublisher<String?, Never> {
        return $username
            .map { name in
                if (name?.count ?? 0) > 2 {
                    self.usernameValidationPublisher.send("valid user name")
                    return name
                }
                self.usernameValidationPublisher.send(nil)
                return nil
        }.eraseToAnyPublisher()
    }

    // on update publisher
    var passwordPublisher: AnyPublisher<String?, Never> {
        return Publishers.CombineLatest($password, $confirmPassword)
            .map { pass, confirmPass in
                if pass == confirmPass, (pass?.count ?? 0) > 0 {
                    self.passwordValidationPublisher.send("password matched")
                    return pass
                }
                self.passwordValidationPublisher.send(nil)
                return nil
        }.eraseToAnyPublisher()
    }

    // on update publisher
    var enableContinuePublisher: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(usernamePublisher, passwordPublisher)
            .map {uname, pass in

                if let username = uname, username.count > 0, let password = pass, password.count > 0 {
                    return true
                }
                return false
        }.eraseToAnyPublisher()

    }

}
