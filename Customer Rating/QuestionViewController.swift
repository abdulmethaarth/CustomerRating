//
//  ViewController.swift
//  Customer Rating
//
//  Created by Admin on 21/07/22.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionCountLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var questions = [
        Question(questionAnswer: DBHelper.getObjectWithQuestionAnswer("How satisfied are you with our products?"), type: .rating(count: 5)),
        Question(questionAnswer: DBHelper.getObjectWithQuestionAnswer("How fair are the prices compared to similar retailers?"), type: .rating(count: 5)),
        Question(questionAnswer: DBHelper.getObjectWithQuestionAnswer("How satisfied are you with the value for money of your purchase?"), type: .rating(count: 5)),
        Question(questionAnswer: DBHelper.getObjectWithQuestionAnswer("On a scale of 1-10 how would you recommend us to your friends and family?"), type: .rating(count: 10)),
        Question(questionAnswer: DBHelper.getObjectWithQuestionAnswer("What could we do to improve our service?"), type: .other)
    ]
    
    var currentIndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI() {
        self.previousBtn?.isHidden = self.currentIndexPath.item <= 0
        self.nextBtn?.setTitle((self.currentIndexPath.item >= (self.questions.count - 1)).title, for: .normal)
        self.skipBtn?.isHidden = self.currentIndexPath.item >= (self.questions.count - 1)
        self.questionCountLbl?.text = "\(self.currentIndexPath.item + 1)/\(self.questions.count)"
        self.collectionView?.scrollToItem(at: self.currentIndexPath, at: .left, animated: false)
        self.collectionView?.reloadData()
    }
    
    var customer: Customer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.leftBarButtonItem = nil
        self.previousBtn?.isHidden = true
        if SessionHelper.isSessionIsActive {
            self.customer = DBHelper.customerWithSessionID(UserDefaults.sessionID)
        } else {
            SessionHelper.createNewSession()
            self.customer = DBHelper.createNewCustomer()
        }
    }

    @IBAction func prevBtnAction(_ sender: UIButton){
        self.currentIndexPath = IndexPath(item: self.currentIndexPath.item-1, section: 0)
    }
    @IBAction func nextBtnAction(_ sender: UIButton){
        if self.currentIndexPath.item == (self.questions.count - 1) {
            let alert = UIAlertController(title: "Alert", message: "Are you sure do you want me to submit", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { [unowned self] action in
                self.dismiss(animated: false, completion: nil)
                DBHelper.saveQuestionAnswers(self.questions.map{$0.questionAnswer} ?? [], forCustomer: self.customer)
                let thankVC = self.storyboard?.instantiateViewController(withIdentifier: "ThanksViewController")
                self.navigationController?.pushViewController(thankVC ?? UIViewController(), animated: true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let answer = self.questions[self.currentIndexPath.item].questionAnswer.answer
            guard answer?.isEmpty == false && answer != nil else { return }
            self.currentIndexPath = IndexPath(item: self.currentIndexPath.item+1, section: 0)
        }
    }
    @IBAction func skipBtnAction(_ sender: UIButton){
        self.currentIndexPath = IndexPath(item: self.currentIndexPath.item+1, section: 0)
    }

}

extension Bool {
    var title: String {
        return self ? "Submit" : "Next"
    }
}

extension QuestionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCollectionViewCell", for: indexPath) as! QuestionCollectionViewCell
        cell.setValues(self.questions[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.size
        return size
    }
}

struct Question {
    var questionAnswer: QuestionAnswer!
    var type: QuestinType!
}

enum QuestinType {
    case rating(count: Int)
    case other
}

class SessionHelper {
    
    static var isSessionIsActive: Bool {
        return UserDefaults.sessionID != nil && UserDefaults.sessionID?.isEmpty == false
    }
    
    static func createNewSession() {
        UserDefaults.sessionID = UUID().uuidString
    }
    
    static func clearCurrentSession() {
        UserDefaults.standard.removeObject(forKey: "SESSION_ID")
        UserDefaults.standard.synchronize()
    }
}

class DBHelper {
    
    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func saveQuestionAnswers(_ questionAnswers: [QuestionAnswer]!, forCustomer customer: Customer) {
        customer.flag = "COMPLETED"
        let managedQuestionAnswers = customer.mutableSetValue(forKey: #keyPath(Customer.questionAnswers))
        questionAnswers.forEach {
            managedQuestionAnswers.add($0)
        }
        customer.addToQuestionAnswers(managedQuestionAnswers)
        try? context.save()
        if let customer = customerWithSessionID(UserDefaults.sessionID) {
            print(Mirror(reflecting: customer), customer.questionAnswers ?? "")
        }
    }
    
    static func createNewCustomer() -> Customer {
        let customer = Customer(context: context)
        customer.id = UserDefaults.sessionID
        customer.flag = "NOT_COMPLETED"
        try? context.save()
        return customer
    }
    
    static func getObjectWithQuestionAnswer(_ question: String!, answer: String! = "") -> QuestionAnswer {
        let questAns = QuestionAnswer(context: context)
        questAns.question = question
        questAns.answer = answer
        return questAns
    }
    
    static func customerWithSessionID(_ sessionID: String!) -> Customer? {
        let request = Customer.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", sessionID)
        return (try? context.fetch(request))?.first
    }
    
}

extension UserDefaults {
    static var sessionID: String? {
        get {
            return UserDefaults.standard.string(forKey: "SESSION_ID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SESSION_ID")
            UserDefaults.standard.synchronize()
        }
    }
}
