import Foundation
import Combine

protocol JLRUserService {
    func authenticate(username: String, password: String, deviceID: String) async throws -> Authentication
    func authenticate(refreshToken: String, deviceID: String) async throws -> Authentication
    func fetchUserByName(accessToken: String, loginName: String, deviceID: String) async throws -> User
    func registerDevice(accessToken: String, username: String, authorizationToken: String, expiresIn: Int, deviceID: String) async throws
    func recoverPassword(userId: String, deviceID: String) async throws
    func fetchUserById(accessToken: String, deviceID: String, userID: String) async throws -> User
    func fetchVehiclesFromUser(accessToken: String, deviceID: String, userID: String) async throws -> [Vehicle]
    func updateUserInfo(accessToken: String, deviceID: String, userID: String) async throws
}

public struct UserService: JLRUserService {
    func fetchUserById(accessToken: String, deviceID: String, userID: String) async throws -> User {
        guard let url = URL(string: "\(URLHost.IF9)/users/\(userID)") else {
            throw APIError.invalidEndpoint
        }
        
        var req = URLRequest(url: url)
        
        req.allHTTPHeaderFields = [
            "Accept": "application/vnd.wirelesscar.ngtp.if9.User-v3+json",
            "Content-Type": "application/json",
            "Authorization":"Bearer \(accessToken)",
            "X-Device-Id": deviceID,
        ]
        
        let (data, _) = try await URLSession.shared.data(for: req)
        
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func fetchVehiclesFromUser(accessToken: String, deviceID: String, userID: String) async throws -> [Vehicle] {
        guard let url = URL(string: "\(URLHost.IF9)/users/\(userID)/vehicles?primaryOnly=true") else {
            throw APIError.invalidEndpoint
        }
        
        var req = URLRequest(url: url)
        
        req.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(accessToken)",
            "X-Device-Id": deviceID,
        ]
        
        let (data, _) = try await URLSession.shared.data(for: req)
        
        return try JSONDecoder().decode([Vehicle].self, from: data)
    }
    
    func updateUserInfo(accessToken: String, deviceID: String, userID: String) async throws {
        guard let url = URL(string: "\(URLHost.IF9)/users/\(userID)") else {
            throw APIError.invalidEndpoint
        }
        
        var req = URLRequest(url: url)
        
        req.allHTTPHeaderFields = [
            "Content-Type": "application/vnd.wirelesscar.ngtp.if9.User-v3+json; charset=utf-8",
            "Authorization":"Bearer \(accessToken)",
            "X-Device-Id": deviceID,
        ]
        
        let (_, _) = try await URLSession.shared.data(for: req)
    }
    
    func recoverPassword(userId: String, deviceID: String) async throws {
        guard let url = URL(string: "\(URLHost.IF9)/users/\(userId)") else {
            throw APIError.invalidEndpoint
        }
        
        var req = URLRequest(url: url)
        
        req.allHTTPHeaderFields = [
            "Accept": "application/vnd.wirelesscar.ngtp.if9.User-v3+json",
            "Content-Type": "application/json",
            "Authorization":"Basic aGlxOnNvbW1hcjEy",
            "X-Device-Id": deviceID,
        ]
        
        let (_, _) = try await URLSession.shared.data(for: req)
    }
    
    func authenticate(refreshToken: String, deviceID: String) async throws -> Authentication {
        let body = RefreshTokenBody(refreshToken: refreshToken)
        return try await makeAuthRequest(body: body, deviceId: deviceID)
    }
    
    func authenticate(username: String, password: String, deviceID: String) async throws -> Authentication {
        let body = AuthBody(username: username, password: password)
        return try await makeAuthRequest(body: body, deviceId: deviceID)
    }
    
    func fetchUserByName(accessToken: String, loginName: String, deviceID: String) async throws -> User {
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
