//
//  File.swift
//  goodzik-ios
//
//  Created by Yehor Myropoltsev on 05.12.2024.
//

import APIClient
import Foundation

extension LoginRequest {
    func toAPI() -> Components.Schemas.LoginRequestDto {
        .init(email: self.email, password: self.password)
    }
}

extension SignupRequest {
    func toAPI() -> Components.Schemas.SignupRequestDto {
        .init(userName: self.userName, email: self.email, password: self.password)
    }
}
