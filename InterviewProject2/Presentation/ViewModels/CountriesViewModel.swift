
import Foundation
import Combine

final class CountriesViewModel: ObservableObject {
    
    @Published var contries: [Country] = []
    @Published var error: Error? = nil
    
    private var fetchTask: AnyCancellable?
    private let service: CountryService
    
    init(service: CountryService) {
        self.service = service
    }
    
    func fetchContries() {
        fetchTask = service.fetchContries()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    print("finish")
                }
            }, receiveValue: { [weak self] response in
                self?.contries = response
            })
    }
    
    func cancelTasks() {
        fetchTask?.cancel()
    }
    
}
