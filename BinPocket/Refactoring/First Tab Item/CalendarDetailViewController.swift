//
//  CalendarDetailViewController.swift
//  BinPocket
//
//  Created by 조성빈 on 5/26/24.
//

import UIKit

class CalendarDetailViewController: UIViewController {
    var navigationTitle: String?
    
    var addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: CalendarDetailViewController.self, action: #selector(addButtonAction))
    
    private var prevButton: UIButton = UIButton()
    private var nextButton: UIButton = UIButton()
    
    private var inComeAmountLabel: UILabel = UILabel()
    private var inComeTableView: UITableView = UITableView(frame: .zero, style: .plain)
    private var inComeView: UIView = UIView()
    
    private var expenseAmountLabel: UILabel = UILabel()
    private var expenseTableView: UITableView = UITableView(frame: .zero, style: .plain)
    private var expenseView: UIView = UIView()
    
    private var tableStackView: UIStackView = UIStackView()
    
    private var totalAmountLabel: UILabel = UILabel()
    private var totalLabelStackView: UIStackView = UIStackView()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = navigationTitle ?? "제목 불러오기 실패"
        self.navigationItem.rightBarButtonItems = [addButton]
        self.view.backgroundColor = .white
        
        setupButtons()
        setupInComeView()
        setupExpenseView()
        setupTableStackView()
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
//        inComeView.addSubview(inComeTableView)
        
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

        tableStackView.addArrangedSubview(inComeView)
        
        NSLayoutConstraint.activate([
            inComeView.topAnchor.constraint(equalTo: tableStackView.topAnchor),
            inComeView.leadingAnchor.constraint(equalTo: tableStackView.leadingAnchor),
            inComeView.trailingAnchor.constraint(equalTo: tableStackView.trailingAnchor),
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
//        expenseView.addSubview(expenseTableView)
        
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
 
        tableStackView.addArrangedSubview(expenseView)
        
        NSLayoutConstraint.activate([
            expenseView.topAnchor.constraint(equalTo: inComeView.bottomAnchor, constant: 10),
            expenseView.leadingAnchor.constraint(equalTo: inComeView.leadingAnchor),
            expenseView.trailingAnchor.constraint(equalTo: inComeView.trailingAnchor),
            expenseView.bottomAnchor.constraint(equalTo: tableStackView.bottomAnchor)
        ])
    }
    
    func setupTableStackView() {
        tableStackView.axis = .vertical
        tableStackView.distribution = .fillEqually
        tableStackView.alignment = .center
        tableStackView.spacing = 20
        tableStackView.backgroundColor = .yellow
        
        tableStackView.addArrangedSubview(inComeView)
        tableStackView.addArrangedSubview(expenseView)
        
        tableStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableStackView)
        
        NSLayoutConstraint.activate([
            tableStackView.topAnchor.constraint(equalTo: prevButton.bottomAnchor, constant: 5),
            tableStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}
