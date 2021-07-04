//
//  ViewController.swift
//  RecipesAppMVVMPractice
//
//  Created by jc on 2021-06-18.
//

import UIKit

class RecipesViewController: UIViewController {
    
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
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(RecipeTableViewCell.self)", for: indexPath) as! RecipeTableViewCell
        cell.recipeTitleLabel.text = "Recipe title"
        cell.recipeSubTitleLabel.text = "Recipe subtitle will come here."
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
