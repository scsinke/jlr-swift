import Foundation
import Combine

struct AuthBody: Encodable {
    private let grantType = "password"
    var username: String
    var password: String
}

struct RefreshTokenBody: Encodable {
    private let grantType = "refresh_token"
    var refreshToken: String
}

func makeAuthRequest<T: Encodable>(body: T, deviceId: String) async throws -> Authentication {
    guard let url = URL(string: "\(URLHost.IFAS.rawValue)/tokens") else {
        throw APIError.invalidEndpoint
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = [
        "Content-Type": "application/json",
        "Authorization":"Basic YXM6YXNwYXNz",
        "X-Device-Id": deviceId,
        "Connection": "Close"
    ]
    
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    
    request.httpBody = try encoder.encode(body)
    
    let (data, _) = try await URLSession.shared.data(for: request)
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    return try decoder.decode(Authentication.self, from: data)
}
