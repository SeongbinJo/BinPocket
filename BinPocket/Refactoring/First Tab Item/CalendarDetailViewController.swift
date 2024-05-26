//
//  CalendarDetailViewController.swift
//  BinPocket
//
//  Created by 조성빈 on 5/26/24.
//

import UIKit

class CalendarDetailViewController: UIViewController {
    var navigationTitle: String = "yyyy년 M월 d일"
    
    var addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: CalendarDetailViewController.self, action: #selector(addButtonAction))
    
    private var prevButton: UIButton = UIButton()
    private var nextButton: UIButton = UIButton()
    
    private var inComeAmountLabel: UILabel = UILabel()
    private var inComeTableView: UITableView = UITableView(frame: .zero, style: .plain)
    private var inComeView: UIView = UIView()
    
    private var expenseAmountLabel: UILabel = UILabel()
    private var expenseTableView: UITableView = UITableView(frame: .zero, style: .plain)
    private var expenseView: UIView = UIView()
    
    private var totalAmountLabel: UILabel = UILabel()
    private var totalLabelStackView: UIStackView = UIStackView()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = navigationTitle
        self.navigationItem.rightBarButtonItems = [addButton]
        self.view.backgroundColor = .white
        
        setupButtons()
        setupInComeView()
        setupExpenseView()
    }

    
    @objc func addButtonAction() {
        print("add button is clicked.")
    }
    
    // UI 레이아웃 배치 메소드
    func setupButtons() {
        prevButton.setImage(UIImage(systemName: "arrowshape.left"), for: .normal)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.addAction(UIAction { _ in
            print("prevButton is clicked.")
        }, for: .touchUpInside)
        
        nextButton.setImage(UIImage(systemName: "arrowshape.right"), for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addAction(UIAction { _ in
            print("nextButton is clicked.")
        }, for: .touchUpInside)
        
        view.addSubview(prevButton)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            prevButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            nextButton.topAnchor.constraint(equalTo: prevButton.topAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    func setupInComeView() {
        let inComeTitleLabel = UILabel()
        inComeTitleLabel.text = "수입"
        inComeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        inComeAmountLabel.text = "없음"
        inComeAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        inComeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "incomeCell")
        inComeTableView.translatesAutoresizingMaskIntoConstraints = false
        
        inComeView.backgroundColor = .red
        
        inComeView.addSubview(inComeTitleLabel)
        inComeView.addSubview(inComeAmountLabel)
        inComeView.addSubview(inComeTableView)
        
        NSLayoutConstraint.activate([
            inComeTitleLabel.topAnchor.constraint(equalTo: inComeView.topAnchor, constant: 10),
            inComeTitleLabel.leadingAnchor.constraint(equalTo: inComeView.leadingAnchor, constant: 10),
            
            inComeAmountLabel.topAnchor.constraint(equalTo: inComeTitleLabel.topAnchor),
            inComeAmountLabel.leadingAnchor.constraint(equalTo: inComeTitleLabel.trailingAnchor, constant: 5),
            
//            inComeTableView.topAnchor.constraint(equalTo: inComeTitleLabel.bottomAnchor, constant: 5),
//            inComeTableView.leadingAnchor.constraint(equalTo: inComeView.leadingAnchor),
//            inComeTableView.trailingAnchor.constraint(equalTo: inComeView.trailingAnchor),
//            inComeTableView.bottomAnchor.constraint(equalTo: inComeView.bottomAnchor)
        ])
        
        inComeView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(inComeView)
        
        NSLayoutConstraint.activate([
            inComeView.topAnchor.constraint(equalTo: prevButton.bottomAnchor, constant: 5),
            inComeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            inComeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            inComeView.heightAnchor.constraint(equalToConstant: 300),
//            inComeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    func setupExpenseView() {
        let expenseTitleLabel = UILabel()
        expenseTitleLabel.text = "지출"
        expenseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        expenseAmountLabel.text = "없음"
        expenseAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        expenseTableView.register(UITableViewCell.self, forCellReuseIdentifier: "expenseCell")
        expenseTableView.translatesAutoresizingMaskIntoConstraints = false
        
        expenseView.backgroundColor = .blue
        
        expenseView.addSubview(expenseTitleLabel)
        expenseView.addSubview(expenseAmountLabel)
        expenseView.addSubview(expenseTableView)
        
        NSLayoutConstraint.activate([
            expenseTitleLabel.topAnchor.constraint(equalTo: expenseView.topAnchor, constant: 10),
            expenseTitleLabel.leadingAnchor.constraint(equalTo: expenseView.leadingAnchor, constant: 10),
            
            expenseAmountLabel.topAnchor.constraint(equalTo: expenseTitleLabel.topAnchor),
            expenseAmountLabel.leadingAnchor.constraint(equalTo: expenseTitleLabel.trailingAnchor, constant: 5),
            
//            inComeTableView.topAnchor.constraint(equalTo: inComeTitleLabel.bottomAnchor, constant: 5),
//            inComeTableView.leadingAnchor.constraint(equalTo: inComeView.leadingAnchor),
//            inComeTableView.trailingAnchor.constraint(equalTo: inComeView.trailingAnchor),
//            inComeTableView.bottomAnchor.constraint(equalTo: inComeView.bottomAnchor)
        ])
        
        expenseView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(expenseView)
        
        NSLayoutConstraint.activate([
            expenseView.topAnchor.constraint(equalTo: inComeView.bottomAnchor, constant: 5),
            expenseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            expenseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            expenseView.heightAnchor.constraint(equalToConstant: 300),
//            inComeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
