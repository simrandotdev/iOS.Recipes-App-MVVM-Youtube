//


import Foundation

protocol RecipesViewModelDelegate: AnyObject {
    func onSuccessfullyRecipesLoaded()
    func onError(error: APIError)
}


class RecipesViewModel {
    
    private(set) var recipes = [Recipe]()
    
    public weak var delegate: RecipesViewModelDelegate?
    
    func getRecipes() {
        do {
            try NetworkingManager.shared.GET(type: RecipesResponse.self,
                                             urlString: "https://recipesapi.herokuapp.com/api/v2/recipes") { result in
                
                switch result {
                
                case .success(let response):
                    print("\(response)")
                    DispatchQueue.main.async {
                        self.recipes = response.recipes
                        self.delegate?.onSuccessfullyRecipesLoaded()
                    }
                case .failure(let error):
                    print("Failed to make API call \(#function) in \(#file) with error: \(error)")
                    DispatchQueue.main.async {
                        self.delegate?.onError(error: error)
                    }
                }
                
            }
        } catch {
            print("Failed to make API call \(#function) in \(#file) with error: \(error)")
        }
    }
}
