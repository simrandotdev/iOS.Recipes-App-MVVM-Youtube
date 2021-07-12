//
//  ViewController.swift
//  RecipesAppMVVMPractice
//
//  Created by jc on 2021-06-18.
//

import UIKit
import SDWebImage

class RecipesViewController: UIViewController {
    
    private var recipes = [Recipe]()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: "\(RecipeTableViewCell.self)")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipes()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    private func getRecipes() {
        do {
            try NetworkingManager.shared.GET(type: RecipesResponse.self,
                                             urlString: "https://recipesapi.herokuapp.com/api/v2/recipes") { result in
                
                switch result {
                
                case .success(let response):
                    print("\(response)")
                    DispatchQueue.main.async {
                        self.recipes = response.recipes
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Failed to make API call \(#function) in \(#file) with error: \(error)")
                }
                
            }
        } catch {
            print("Failed to make API call \(#function) in \(#file) with error: \(error)")
        }
    }
    
}

extension RecipesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(RecipeTableViewCell.self)", for: indexPath) as! RecipeTableViewCell
        let recipe = recipes[indexPath.row]
        cell.recipeTitleLabel.text = recipe.title.withoutHtml
        cell.recipeSubTitleLabel.text = "\(recipe.publisher)\n\(recipe.publishedId)\n\(String(format: "%.2f", recipe.socialScore))"
        cell.recipeImageView.sd_setImage(with: URL(string: recipe.imageUrl))
        return cell
    }
}

private extension RecipesViewController {
    func setupUI() {
        title = "Recipes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
}
