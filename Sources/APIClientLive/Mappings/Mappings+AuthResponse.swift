//
//  File.swift
//  goodzik-ios
//
//  Created by Yehor Myropoltsev on 05.12.2024.
//

import APIClient
import Foundation
import SharedModels

extension Components.Schemas.SignupResponseDto {
    func toDomain() -> AuthResponse {
        AuthResponse(accessToken: self.accessToken, user: self.user.toDomain())
    }
}

extension Components.Schemas.LoginResponseDto {
    func toDomain() -> AuthResponse {
        AuthResponse(accessToken: self.accessToken, user: self.user.toDomain())
    }
}
