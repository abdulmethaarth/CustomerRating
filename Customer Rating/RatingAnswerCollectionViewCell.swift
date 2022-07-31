//
//  RatingAnswerCollectionViewCell.swift
//  Customer Rating
//
//  Created by Admin on 21/07/22.
//

import UIKit

class RatingAnswerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var answerLbl: UILabel!
    
    func setValues(_ value: String!, isSelected: Bool = false) {
        self.answerLbl?.text = value
        self.answerLbl?.backgroundColor = isSelected ? .red : .white
        self.answerLbl?.textColor = isSelected ? .white : .black
        self.answerLbl.layer.cornerRadius = 15
        self.layer.cornerRadius = 15
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.answerLbl.layer.cornerRadius = self.answerLbl.bounds.width/2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.answerLbl?.backgroundColor = .white
        self.answerLbl?.textColor = .black
    }
}
