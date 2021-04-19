import Foundation
import Combine

struct RefreshTokenBody: Encodable {
    private let grantType = "refresh_token"
    var refreshToken: String
}

public func RefreshToken(token: String, deviceID: String) -> AnyPublisher<Authentication, Error> {
    
    let body = RefreshTokenBody(refreshToken: token)
    
    guard let url = URL(string: "\(URLHost.IFAS.rawValue)/tokens") else {
        return Fail(error: APIError.invalidEndpoint)
            .eraseToAnyPublisher()
    }
    
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = [
        "Content-Type": "application/json",
        "Authorization":"Basic YXM6YXNwYXNz",
        "X-Device-Id": deviceID,
        "Connection": "Close"
    ]
    
    do {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(body)
    } catch {
        return Fail(error: error)
            .eraseToAnyPublisher()
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    return URLSession.shared.publisher(for: request, decoder: decoder)
}
