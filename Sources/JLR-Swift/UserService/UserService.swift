import Foundation
import Combine

protocol JLRUserService {
    func authenticate(username: String, password: String, deviceID: String) async throws -> Authentication
    func authenticate(refreshToken: String, deviceID: String) async throws -> Authentication
    func fetchUser(accessToken: String, loginName: String, deviceID: String) async throws -> User
    func registerDevice(accessToken: String, username: String, authorizationToken: String, expiresIn: Int, deviceID: String) async throws -> Void
}

public struct UserService: JLRUserService {
    func authenticate(refreshToken: String, deviceID: String) async throws -> Authentication {
        let body = RefreshTokenBody(refreshToken: refreshToken)
        return try await makeAuthRequest(body: body, deviceId: deviceID)
    }
    
    func authenticate(username: String, password: String, deviceID: String) async throws -> Authentication {
        let body = AuthBody(username: username, password: password)
        return try await makeAuthRequest(body: body, deviceId: deviceID)
    }
    
    func fetchUser(accessToken: String, loginName: String, deviceID: String) async throws -> User {
        guard let url = URL(string: "\(URLHost.IF9)/users?loginName=\(loginName)}") else {
            throw APIError.invalidEndpoint
        }
        
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = [
            "Accept": "application/vnd.wirelesscar.ngtp.if9.User-v3+json",
            "Content-Type": "application/json",
            "Authorization":"Bearer \(accessToken)",
            "X-Device-Id": deviceID,
        ]
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func registerDevice(accessToken: String, username: String, authorizationToken: String, expiresIn: Int, deviceID: String) async throws {
        guard let url = URL(string: "\(URLHost.IFOP)/users/\(username)/clients ") else {
            throw APIError.invalidEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(accessToken)",
            "X-Device-Id": deviceID,
            "Connection": "close",
        ]
        
        let body = registerDeviceBody(access_token: accessToken, authorization_token: authorizationToken, expires_in: expiresIn, deviceId: deviceID)
        
        request.httpBody = try JSONEncoder().encode(body)
        
        _ = try await URLSession.shared.data(for: request)
    }
}

struct registerDeviceBody: Encodable {
    var access_token: String
    var authorization_token: String
    var expires_in: Int
    var deviceId: String
}
