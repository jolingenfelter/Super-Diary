//
//  EntryCell.swift
//  SuperDiary
//
//  Created by Joanna Lingenfelter on 2/28/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
    
    static let reuseIdentifier = "\(EntryCell.self)"
    
    let entryDateLabel = UILabel()
    let entryTextLabel = UILabel()
    let entryImageView = UIImageView()
    let ratingImageView = UIImageView()
    
    override func layoutSubviews() {
        
        self.contentView.frame = self.bounds
        
        // MARK: - ImageView
        
        self.contentView.addSubview(entryImageView)
        entryImageView.contentMode = .scaleAspectFill
        entryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            entryImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            entryImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            entryImageView.heightAnchor.constraint(equalToConstant: 60),
            entryImageView.widthAnchor.constraint(equalTo: entryImageView.heightAnchor)
            ])
        
        // MARK: - RatingImageView
        
        self.contentView.addSubview(ratingImageView)
        ratingImageView.roundImage()
        ratingImageView.contentMode = .scaleToFill
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ratingImageView.centerXAnchor.constraint(equalTo: entryImageView.centerXAnchor, constant: 20),
            ratingImageView.topAnchor.constraint(equalTo: entryImageView.centerYAnchor, constant: 15),
            ratingImageView.heightAnchor.constraint(equalToConstant: 25),
            ratingImageView.widthAnchor.constraint(equalTo: ratingImageView.heightAnchor)])
        
        // MARK: - DateLabel
        
        self.contentView.addSubview(entryDateLabel)
        entryDateLabel.textColor = UIColor(colorLiteralRed: 39/255, green: 107/255, blue: 134/255, alpha: 1)
        entryDateLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        entryDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            entryDateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 30),
            entryDateLabel.leadingAnchor.constraint(equalTo: entryImageView.trailingAnchor, constant: 10),
            entryDateLabel.widthAnchor.constraint(equalToConstant: 200),
            entryDateLabel.heightAnchor.constraint(equalToConstant: 25)])
        
        // MARK: - TextLabel
        
        self.contentView.addSubview(entryTextLabel)
        entryTextLabel.textColor = UIColor.lightGray
        entryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            entryTextLabel.topAnchor.constraint(equalTo: entryDateLabel.bottomAnchor, constant: 2),
            entryTextLabel.leadingAnchor.constraint(equalTo: entryDateLabel.leadingAnchor, constant: 15),
            entryTextLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            entryTextLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
            ])
        
    }
    
    func configureCell(forEntry entry: Entry) {
        
        entryDateLabel.text = dateFormatter.string(from: entry.date)
        entryTextLabel.text = entry.note
        
        if entry.userImage != nil {
            
            DispatchQueue.main.async {
                
                self.entryImageView.roundImage()
                self.entryImageView.image = entry.userImage
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.entryImageView.roundImage()
                self.entryImageView.image = UIImage(named: "icn_noimage")
            }

        }
        
        if let entryRating = entry.rating {
            
            ratingImageView.isHidden = false
            let rating = Rating(rawValue: entryRating)!
            
            switch rating {
                
            case .Super:
                
                ratingImageView.image = UIImage(named: "icn_happy")
                
            case .Fine:
                
                ratingImageView.image = UIImage(named: "icn_average")
                
            case .Substandard:
                
                ratingImageView.image = UIImage(named: "icn_bad")
            }
            
        } else {
            ratingImageView.isHidden = true
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
