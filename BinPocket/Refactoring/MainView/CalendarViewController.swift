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
    private lazy var inComeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "수입"
        return label
    }()
    
    private lazy var inComeAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    
    private lazy var inComeBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .red
        backgroundView.layer.cornerRadius = 10
        
        inComeAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        inComeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(inComeTitleLabel)
        backgroundView.addSubview(inComeAmountLabel)
        NSLayoutConstraint.activate([
            inComeTitleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 5),
            inComeTitleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            inComeAmountLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            inComeAmountLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
        ])
        
        return backgroundView
    }()
    // 수입 컨테이너 끝
    
    // 지출 컨테이너 시작
    private lazy var extenseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지출"
        return label
    }()
    
    private lazy var extenseAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    
    private lazy var expenseBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .blue
        backgroundView.layer.cornerRadius = 10
        
        backgroundView.addSubview(extenseTitleLabel)
        backgroundView.addSubview(extenseAmountLabel)
        
        extenseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        extenseAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            extenseTitleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 5),
            extenseTitleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            extenseAmountLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            extenseAmountLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
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
    
    // 총 합계 컨테이너 시작
    private lazy var totalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Total"
        return label
    }()
    
    private lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    
    private lazy var totalBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .gray
        backgroundView.layer.cornerRadius = 10
        
        backgroundView.addSubview(totalTitleLabel)
        backgroundView.addSubview(totalAmountLabel)
        
        totalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalTitleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 5),
            totalTitleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            totalAmountLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            totalAmountLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
        ])
        return backgroundView
    }()
    // 총 합계 컨테이너 끝

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "빈주머니"
        
        let views = [calendarView, finaceStackView, totalBackgroundView]
        for component in views {
            component.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(component)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            calendarView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),

            finaceStackView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
            finaceStackView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            finaceStackView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            finaceStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            totalBackgroundView.topAnchor.constraint(equalTo: finaceStackView.bottomAnchor, constant: 10),
            totalBackgroundView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            totalBackgroundView.leadingAnchor.constraint(equalTo: finaceStackView.leadingAnchor),
            totalBackgroundView.trailingAnchor.constraint(equalTo: finaceStackView.trailingAnchor),
            totalBackgroundView.heightAnchor.constraint(equalToConstant: 80)
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
