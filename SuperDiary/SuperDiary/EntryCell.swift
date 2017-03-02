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
    
    let noteDateLabel = UILabel()
    let noteTextLabel = UILabel()
    let noteImageView = UIImageView()
    
    override func layoutSubviews() {
        
        self.contentView.addSubview(noteImageView)
        self.noteImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            noteImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            noteImageView.heightAnchor.constraint(equalToConstant: 60),
            noteImageView.widthAnchor.constraint(equalTo: noteImageView.heightAnchor)
            ])
        
        self.contentView.addSubview(noteDateLabel)
        self.noteDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteDateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            noteDateLabel.leadingAnchor.constraint(equalTo: noteImageView.trailingAnchor, constant: 10),
            noteDateLabel.widthAnchor.constraint(equalToConstant: 200),
            noteDateLabel.heightAnchor.constraint(equalToConstant: 30)])
        
        self.contentView.addSubview(noteTextLabel)
        self.noteTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteTextLabel.topAnchor.constraint(equalTo: noteDateLabel.bottomAnchor, constant: 5),
            noteTextLabel.leadingAnchor.constraint(equalTo: noteDateLabel.leadingAnchor),
            noteTextLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            noteTextLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
            ])
        
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(withEntry entry: Entry) {
        
        self.noteDateLabel.text = dateFormatter.string(from: entry.date)
        self.noteTextLabel.text = entry.note
        
        if let image = entry.image {
            self.noteImageView.image = UIImage(data: image as Data)
            self.noteImageView.roundImage()
        } else {
            self.noteImageView.image = UIImage(named: "icn_noimage")
            self.noteImageView.roundImage()
        }
        
    }

}
