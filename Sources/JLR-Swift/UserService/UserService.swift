import Foundation
import Combine

protocol JLRUserService {
    func authenticate(refreshToken: String, deviceID: String) -> AnyPublisher<Authentication, Error>
    
    func authenticate(username: String, password: String, deviceID: String) -> AnyPublisher<Authentication, Error>
    
    func fetchUser(accessToken: String, loginName: String, deviceID: String) -> AnyPublisher<User, Error>
    
    func registerDevice(accessToken: String, username: String, authorizationToken: String, expiresIn: Int, deviceID: String) -> AnyPublisher<Void, Error>
}

public struct UserService: JLRUserService {
    
    
    func authenticate(refreshToken: String, deviceID: String) -> AnyPublisher<Authentication, Error> {
        let body = RefreshTokenBody(refreshToken: refreshToken)
        return makeAuthRequest(body: body, deviceId: deviceID)
    }
    
    func authenticate(username: String, password: String, deviceID: String) -> AnyPublisher<Authentication, Error> {
        let body = AuthBody(username: username, password: password)
        return makeAuthRequest(body: body, deviceId: deviceID)
    }
    
    func fetchUser(accessToken: String, loginName: String, deviceID: String) -> AnyPublisher<User, Error> {
        guard let url = URL(string: "\(URLHost.IF9)/users?loginName=\(loginName)}") else {
            return Fail(error: APIError.invalidEndpoint)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = [
            "Accept": "application/vnd.wirelesscar.ngtp.if9.User-v3+json",
            "Content-Type": "application/json",
            "Authorization":"Bearer \(accessToken)",
            "X-Device-Id": deviceID,
        ]
        
        return URLSession.shared.publisher(for: request)
    }
    
    func registerDevice(accessToken: String, username: String, authorizationToken: String, expiresIn: Int, deviceID: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "\(URLHost.IFOP)/users/\(username)/clients ") else {
            return Fail(error: APIError.invalidEndpoint)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(accessToken)",
            "X-Device-Id": deviceID,
            "Connection": "close",
        ]
        
        let body = [
            "access_token": accessToken,
            "authorization_token": authorizationToken,
            "expires_in": expiresIn,
            "deviceID": deviceID,
        ] as [String : Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.publisher(for: request)
    }
}
