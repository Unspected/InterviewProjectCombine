
import SwiftUI

struct CountriesView: View {
    
    @StateObject var viewModel: CountriesViewModel
    
    init(service: CountryService) {
        _viewModel = .init(wrappedValue: CountriesViewModel(service: service))
    }
    
    var body: some View {
        List(viewModel.contries) { country in
            HStack {
                AsyncImage(url: country.imageUrl) { image in
                    image.image?.resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                
                Text(country.name)
            }
        }
        .onAppear {
            viewModel.fetchContries()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
    }
}

#Preview {
    CountriesView(service: NetworkCountryService())
}
