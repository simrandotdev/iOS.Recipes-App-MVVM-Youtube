//


import Foundation

protocol RecipesViewModelDelegate: AnyObject {
    func onSuccessfullyRecipesLoaded()
    func onError(error: APIError)
}


class RecipesViewModel {
    
    private(set) var recipes = [Recipe]()
    
    public weak var delegate: RecipesViewModelDelegate?
    
    private let repo = RecipeRepositories()
    
    func getRecipes() {
        repo.getRecipes { result in
            switch result {
            
            case .success(let recipes):
                print("\(recipes)")
                DispatchQueue.main.async {
                    self.recipes = recipes
                    self.delegate?.onSuccessfullyRecipesLoaded()
                }
            case .failure(let error):
                print("Failed to make API call \(#function) in \(#file) with error: \(error)")
                DispatchQueue.main.async {
                    self.delegate?.onError(error: error)
                }
            }
        }
    }
}
