import Foundation
import Combine

//https://www.ralfebert.de/examples/v3/countries.json
//{
//"id": "at",
//"capital": "Vienna",
//"name": "Austria",
//"population": 8935112,
//"imageUrl": "https://www.ralfebert.de/examples/v3/at.jpg"
//},
//{

enum APIEndPoints {
    case countries
    
    var url: URL {
        switch self {
        case .countries: URL(string: "https://www.ralfebert.de/examples/v3/countries.json")!
        }
    }
}

final class NetworkCountryService: CountryService {
    
    private let decoder: JSONDecoder
    
    private let urlSession: URLSession
    
    init(decoder: JSONDecoder = JSONDecoder(), urlSession: URLSession = .shared) {
        self.decoder = decoder
        self.urlSession = urlSession
    }
    
    private func fetch<T:Decodable>(endPoint: APIEndPoints) -> AnyPublisher<T, Error> {
        urlSession.dataTaskPublisher(for: endPoint.url)
            .map { $0.data }
            .decode(type: T.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - CountryService
    func fetchContries() -> AnyPublisher<[Country], any Error> {
        fetch(endPoint: .countries)
    }
    
}

extension Country: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case capital
        case name
        case population
        case imageUrl
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.capital = try container.decode(String.self, forKey: .capital)
        self.name = try container.decode(String.self, forKey: .name)
        self.population = try container.decode(Int.self, forKey: .population)
        self.imageUrl = try container.decode(URL.self, forKey: .imageUrl)
    }
}

