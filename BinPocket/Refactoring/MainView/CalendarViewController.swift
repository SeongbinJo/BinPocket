//
//  CalendarViewController.swift
//  BinPocket
//
//  Created by 조성빈 on 5/17/24.
//

import UIKit

class CalendarViewController: UIViewController {
    
    private lazy var calendarView: UIView = {
        let calendarView = UIView()
        calendarView.backgroundColor = .red
        return calendarView
    }()
    
    // 수입 컨테이너 시작
    private lazy var inComeLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    
    private lazy var inComeLabelStackView: UIStackView = {
        let inComeLabelStackView = UIStackView()
        inComeLabelStackView.axis = .vertical
        inComeLabelStackView.alignment = .center
        inComeLabelStackView.spacing = 0
        inComeLabelStackView.backgroundColor = .yellow
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fill
        hStackView.alignment = .center
        let inComeTitleLabel = UILabel()
        inComeTitleLabel.text = "수입"
        let wonLabel = UILabel()
        wonLabel.text = "원"
        hStackView.addArrangedSubview(inComeLabel)
        hStackView.addArrangedSubview(wonLabel)
        inComeLabelStackView.addArrangedSubview(inComeTitleLabel)
        inComeLabelStackView.addArrangedSubview(hStackView)
        return inComeLabelStackView
    }()
    
    private lazy var inComeBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .red
        backgroundView.layer.cornerRadius = 10
        
        backgroundView.addSubview(inComeLabelStackView)
        inComeLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inComeLabelStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            inComeLabelStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            inComeLabelStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            inComeLabelStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
        ])
        
        return backgroundView
    }()
    // 수입 컨테이너 끝
    
    // 지출 컨테이너 시작
    private lazy var expenseLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    
    private lazy var expenseLabelStackView: UIStackView = {
        let expenseLabelStackView = UIStackView()
        expenseLabelStackView.axis = .vertical
        expenseLabelStackView.alignment = .center
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        let expenseTitleLabel = UILabel()
        expenseTitleLabel.text = "지출"
        let wonLabel = UILabel()
        wonLabel.text = "원"
        hStackView.addArrangedSubview(expenseLabel)
        hStackView.addArrangedSubview(wonLabel)
        expenseLabelStackView.addArrangedSubview(expenseTitleLabel)
        expenseLabelStackView.addArrangedSubview(hStackView)
        return expenseLabelStackView
    }()
    
    private lazy var expenseBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .blue
        backgroundView.layer.cornerRadius = 10
        
        backgroundView.addSubview(expenseLabelStackView)
        expenseLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expenseLabelStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            expenseLabelStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            expenseLabelStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            expenseLabelStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
        ])
        
        return backgroundView
    }()
    // 지출 컨테이너 끝
    
    // 수입, 지출 컨테이너 StackView
    private lazy var finaceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.addArrangedSubview(inComeBackgroundView)
        stackView.addArrangedSubview(expenseBackgroundView)
        return stackView
    }()
    
    private lazy var totalLabelStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "빈주머니"
        
        let views = [calendarView, finaceStackView]
        for component in views {
            component.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(component)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            calendarView.heightAnchor.constraint(equalToConstant: 400),

            finaceStackView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
            finaceStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -150),
            finaceStackView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            finaceStackView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
        ])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
