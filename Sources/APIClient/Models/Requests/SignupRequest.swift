import Foundation

public struct SignupRequest: Codable {
    public let userName: String
    public let email: String
    public let password: String

    public init(userName: String, email: String, password: String) {
        self.userName = userName
        self.email = email
        self.password = password
    }
}
