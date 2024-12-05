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
