import Foundation
import Combine

protocol CountryService {
    
    func fetchContries() -> AnyPublisher<[Country], Error>
}


