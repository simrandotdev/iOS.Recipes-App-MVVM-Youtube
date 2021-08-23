//


import Foundation

class RecipeRepositories {
    
    private let http: NetworkingManager
    
    init(with networkingManager: NetworkingManager) {
        self.http = networkingManager
    }
    
    
    func getRecipes(completion: @escaping (Result<[Recipe], APIError>) -> Void) {
        do {
            try http.GET(type: RecipesResponse.self,
                                             urlString: "https://recipesapi.herokuapp.com/api/v2/recipes") { result in
                
                switch result {
                
                case .success(let response):
                    print("\(response)")
                    completion(.success(response.recipes))
                case .failure(let error):
                    print("Failed to make API call \(#function) in \(#file) with error: \(error)")
                    completion(.failure(error))
                }
                
            }
        } catch {
            print("Failed to make API call \(#function) in \(#file) with error: \(error)")
        }
    }
}
