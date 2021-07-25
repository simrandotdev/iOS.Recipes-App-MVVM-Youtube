//
//  ViewController.swift
//  RecipesAppMVVMPractice
//
//  Created by jc on 2021-06-18.
//

import UIKit
import SDWebImage

class RecipesViewController: UIViewController {
    
    private let recipesViewModel = RecipesViewModel()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: "\(RecipeTableViewCell.self)")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        recipesViewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
        recipesViewModel.getRecipes()
    }
}

extension RecipesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesViewModel.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(RecipeTableViewCell.self)", for: indexPath) as! RecipeTableViewCell
        let recipe = recipesViewModel.recipes[indexPath.row]
        cell.recipeTitleLabel.text = recipe.title.withoutHtml
        cell.recipeSubTitleLabel.text = "\(recipe.publisher)\n\(recipe.publishedId)\n\(String(format: "%.2f", recipe.socialScore))"
        cell.recipeImageView.sd_setImage(with: URL(string: recipe.imageUrl))
        return cell
    }
}

extension RecipesViewController: RecipesViewModelDelegate {
    func onSuccessfullyRecipesLoaded() {
        self.tableView.reloadData()
    }
    
    func onError(error: APIError) {
        print("ERROR: \(error.localizedDescription)")
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
