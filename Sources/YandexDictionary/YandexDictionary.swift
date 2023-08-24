import Foundation

public struct TranslationResponse: Codable {
    public let def: [Definition]
}

public struct Definition: Codable {
    public let text: String
    public let pos: String
    public let tr: [Translation]
}

public struct Translation: Codable {
    public let text: String
    public let pos: String?
    public let syn: [Synonym]?
    public let mean: [Meaning]?
    public let ex: [Example]?
}

public struct Synonym: Codable {
    public let text: String
}

public struct Meaning: Codable {
    public let text: String
}

public struct Example: Codable {
    public let text: String
    public let tr: [Translation]?
}

public struct YandexAPIError: Error, CustomStringConvertible, Codable, Equatable {
    let code: Int
    let message: String
    
    public var description: String {
        message
    }
}

public enum CommonAPIError: Error, CustomStringConvertible {
    
    case undefined
    
    public var description: String {
        "Undefined API error"
    }
    
}

public struct YandexDictionary {
    
    let session: URLSession
    
    let key: String
    
    let jsonDecoder = JSONDecoder()
    
    var baseURL: URL {
        URL(string: "https://dictionary.yandex.net/api/v1/dicservice.json")!.appending(queryItems: [
            URLQueryItem(name: "key", value: key)
        ])
    }
    
    public init(
        session: URLSession = .shared,
        key: String
    ) {
        self.session = session
        self.key = key
    }
    
}

public extension YandexDictionary {
    
    func translate(_ text: String, source: String, target: String) async throws -> TranslationResponse {
        let url = baseURL.appending(component: "lookup").appending(queryItems: [
            URLQueryItem(name: "lang", value: "\(source)-\(target)"),
            URLQueryItem(name: "text", value: text),
        ])
        
        return try await data(from: url)
    }
    
    func languages() async throws -> [String] {
        let url = baseURL.appending(component: "getLangs")
        
        return try await data(from: url)
    }
    
}

private extension YandexDictionary {
    
    func data<T>(from url: URL) async throws  -> T where T: Codable {
        let (data, response) = try await session.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let error = try? jsonDecoder.decode(YandexAPIError.self, from: data)
            throw error ?? CommonAPIError.undefined
        }
        
        let result = try jsonDecoder.decode(T.self, from: data)
        
        return result
    }
    
}
