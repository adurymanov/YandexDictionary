import XCTest
@testable import YandexDictionary

final class YandexDictionaryTests: XCTestCase {
    
    let validAPIKey: String = <#Valid API key#>
    
    let invalidAPIKey: String = "dict.1.1.20230824T022118Z.76da5acd51aaae8f.f4152d12f97002q43234234423432423425443"
    
    func testInvalidAPIKey() async throws {
        let dictionary = YandexDictionary(key: invalidAPIKey)
        let exceptError = YandexAPIError(code: 401, message: "API key is invalid")
        var apiError: YandexAPIError?
        
        do {
            let translation = try await dictionary.translate("hello", source: "en", target: "ru")
        } catch {
            apiError = error as? YandexAPIError
        }
        
        XCTAssertEqual(apiError, exceptError)
    }
    
    func testValidAPIKey() async throws {
        let dictionary = YandexDictionary(key: validAPIKey)
        
        let translation = try await dictionary.translate("hello", source: "en", target: "ru")
        
        XCTAssert(true)
    }
    
}
