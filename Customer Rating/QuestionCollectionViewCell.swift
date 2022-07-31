//
//  CollectionViewCell.swift
//  Customer Rating
//
//  Created by Admin on 21/07/22.
//

import UIKit

class QuestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    
    private var question: Question!
    
    var selectedIndexPath: IndexPath?
    
    func setValues(_ question: Question) {
        self.questionLbl?.text = question.questionAnswer.question
        self.question = question
        switch question.type {
        case .rating(_):
            collectionView.isHidden = false
            textField?.isHidden = true
        case .other:
            collectionView.isHidden = true
            textField?.isHidden = false
        default:
            break
        }
        collectionView?.reloadData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectedIndexPath = nil
    }
    
}

extension QuestionCollectionViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string.uppercased())
        self.question.questionAnswer.answer = newString
        return true
    }
}

extension QuestionCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch question.type {
        case .rating(let count):
            return count
        case .other:
            return 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingAnswerCollectionViewCell", for: indexPath) as! RatingAnswerCollectionViewCell
        cell.setValues((indexPath.item+1).stringValue, isSelected: self.selectedIndexPath == indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.question.questionAnswer.answer = (indexPath.item+1).stringValue
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = collectionView.bounds.size
        switch question.type {
        case .rating(let count):
            size.width = (collectionView.bounds.width -  (CGFloat(count) * 5)) / CGFloat(count)
        case .other: break
        default: break
        }
        return size
    }
}

extension Int {
    var stringValue: String? {
        return String(self)
    }
}
