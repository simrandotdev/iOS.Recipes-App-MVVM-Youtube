//


import Foundation

class RecipeItemViewModel {
    var recipeTitle: String {
        return recipe.title
    }
    var recipeSubtitle: String {
        return "\(recipe.title)\n\(recipe.publishedId)\n\(String(format: "%.2f", recipe.socialScore))"
    }
    var recipeImageUrl: String {
        return recipe.imageUrl
    }
    
    private var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
