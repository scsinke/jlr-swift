import Foundation
import Combine

struct AuthBody: Encodable {
    private let grantType = "password"
    var username: String
    var password: String
}

public func Authenticate(username: String, password: String, deviceID: String) async throws -> Authentication {
    let body = AuthBody(username: username, password: password)
    
    guard let url = URL(string: "\(URLHost.IFAS.rawValue)/tokens") else {
        throw APIError.invalidEndpoint
    }
    
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = [
        "Content-Type": "application/json",
        "Authorization":"Basic YXM6YXNwYXNz",
        "X-Device-Id": deviceID,
        "Connection": "Close"
    ]

    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    request.httpBody = try encoder.encode(body)
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try decoder.decode(Authentication.self, from: data)
}
