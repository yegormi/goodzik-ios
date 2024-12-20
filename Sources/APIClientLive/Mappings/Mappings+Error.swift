import APIClient
import Foundation

extension Components.Schemas.ApiErrorDto {
    func toDomain() -> APIErrorPayload {
        .init(code: self.code?.toDomain() ?? .internalError, message: self.message)
    }
}

extension Components.Schemas.ApiErrorDto.codePayload {
    func toDomain() -> APIErrorPayload.Code {
        switch self {
        case ._internal:
            .internalError
        case .entity_hyphen_not_hyphen_found:
            .entityNotFound
        case .email_hyphen_not_hyphen_unique:
            .emailNotUnique
        case .unauthorized:
            .unauthorized
        case .forbidden:
            .forbidden
        }
    }
}
