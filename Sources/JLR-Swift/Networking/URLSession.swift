import Foundation
import Combine

extension URLSession {
    func publisher<T: Decodable>(
        for request: URLRequest,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<T, Error> {
        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func publisher(for request: URLRequest) -> AnyPublisher<Void, Error> {
        return dataTaskPublisher(for: request)
            .tryMap() { element in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }

                return Void()
            }
            .eraseToAnyPublisher()
    }
}
