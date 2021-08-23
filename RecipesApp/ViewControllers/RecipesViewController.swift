import UIKit
import SDWebImage

class RecipesViewController: UIViewController {
    
    private let recipesViewModel: RecipesViewModel
    
    init(recipesViewModel: RecipesViewModel) {
        self.recipesViewModel = recipesViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let recipeViewModel = recipesViewModel.recipes[indexPath.row]
        cell.bind(viewModel: recipeViewModel)
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
