//
//  RecipeTableViewCell.swift
//  RecipesAppMVVMPractice
//
//  Created by jc on 2021-06-20.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    var recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .gray.withAlphaComponent(0.65)
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    var recipeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    
    var recipeSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(recipeImageView)
        addSubview(recipeTitleLabel)
        addSubview(recipeSubTitleLabel)
        
        NSLayoutConstraint.activate([
            recipeImageView.heightAnchor.constraint(equalToConstant: 75),
            recipeImageView.widthAnchor.constraint(equalToConstant: 75),
            recipeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            
            recipeTitleLabel.topAnchor.constraint(equalTo: recipeImageView.topAnchor),
            recipeTitleLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 8),
            recipeTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            recipeSubTitleLabel.topAnchor.constraint(equalTo: recipeTitleLabel.bottomAnchor, constant: 8),
            recipeSubTitleLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 8),
            recipeSubTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
}
