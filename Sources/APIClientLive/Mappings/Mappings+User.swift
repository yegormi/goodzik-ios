import APIClient
import Foundation
import SharedModels

extension Components.Schemas.UserDto {
    func toDomain() -> User {
        User(
            id: self.id,
            username: self.userName,
            email: self.email,
            role: self.role
        )
    }
}
