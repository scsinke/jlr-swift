import Foundation

public struct Authentication {
    var accessToken: String
    var authorizationToken: String
    var expiresIn: Int
    var refreshToken: String
    var tokenType: String
}

extension Authentication: Decodable {
    enum CodingKeys: String, CodingKey {
        case accessToken, authorizationToken, expiresIn, refreshToken, tokenType
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try values.decode(String.self, forKey: .accessToken)
        authorizationToken = try values.decode(String.self, forKey: .authorizationToken)
        let expiresInString = try values.decode(String.self, forKey: .expiresIn)
        expiresIn = Int(expiresInString)!
        refreshToken = try values.decode(String.self, forKey: .refreshToken)
        tokenType = try values.decode(String.self, forKey: .tokenType)
    }
}
