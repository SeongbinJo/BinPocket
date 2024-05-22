//
//  CalendarViewController.swift
//  BinPocket
//
//  Created by 조성빈 on 5/17/24.
//

import UIKit

class CalendarViewController: UIViewController {
    
    // 달력 컨테이너 시작
    private var calendarCollectionView: UICollectionView!
    
    private var prevMonthButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.left")
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var currentYearMonth: UILabel = {
        let label = UILabel()
        label.text = "yyyy년 mm월"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var nextMonthButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var todayButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        var config = UIButton.Configuration.filled()
        config.title = "Today"
        config.background.backgroundColor = .black
        button.configuration = config
        button.addAction(UIAction { _ in
            print("Clicked Today Button.")
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var calendarNavigationBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(prevMonthButton)
        stackView.addArrangedSubview(currentYearMonth)
        stackView.addArrangedSubview(nextMonthButton)

        return stackView
    }()
    
    private lazy var calendarView: UIView = {
        let calendarView = UIView()
        calendarView.backgroundColor = .yellow
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.addSubview(calendarNavigationBarStackView)
        calendarView.addSubview(todayButton)
        calendarView.addSubview(weekOfDayStackView)
//        calendarView.addSubview(calendarCollectionView)
        
        
        NSLayoutConstraint.activate([
            calendarNavigationBarStackView.topAnchor.constraint(equalTo: calendarView.topAnchor),
            calendarNavigationBarStackView.centerXAnchor.constraint(equalTo: calendarView.centerXAnchor),
            
            todayButton.topAnchor.constraint(equalTo: calendarNavigationBarStackView.topAnchor),
            todayButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: -5),
            
            weekOfDayStackView.topAnchor.constraint(equalTo: todayButton.bottomAnchor, constant: 10),
            weekOfDayStackView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            weekOfDayStackView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor)
            
//            calendarCollectionView.topAnchor.constraint(equalTo: calendarNavigationBarStackView.bottomAnchor, constant: 5),
//            calendarCollectionView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
//            calendarCollectionView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
//            calendarCollectionView.bottomAnchor.constraint(equalTo: calendarView.bottomAnchor)
        ])
        return calendarView
    }()
    // 달력 컨테이너 끝

    // 수입 View
    private lazy var inComeAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var inComeAmountView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        
        let inComeTitle = UILabel()
        inComeTitle.text = "수입"
        inComeTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let wonLabel = UILabel()
        wonLabel.text = "원"
    
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fill
        hStackView.alignment = .center
        hStackView.addArrangedSubview(inComeAmountLabel)
        hStackView.addArrangedSubview(wonLabel)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(inComeTitle)
        view.addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            inComeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inComeTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            
            hStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 지출 View
    private lazy var expenseAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    
    private lazy var expenseAmountView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        
        let expenseTitle = UILabel()
        expenseTitle.text = "지출"
        expenseTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let wonLabel = UILabel()
        wonLabel.text = "원"
    
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fill
        hStackView.alignment = .center
        hStackView.addArrangedSubview(expenseAmountLabel)
        hStackView.addArrangedSubview(wonLabel)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(expenseTitle)
        view.addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            expenseTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            expenseTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            
            hStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Total View
    private lazy var totalAmountView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        let totalTitle = UILabel()
        totalTitle.text = "총합"
        totalTitle.translatesAutoresizingMaskIntoConstraints = false
        
        // 이 부분은 후에 inComeAmountLabel + expenseAmontLabel의 값으로 대체
        let totalAmountLabel = UILabel()
        totalAmountLabel.text = "0"
        
        let wonLabel = UILabel()
        wonLabel.text = "원"
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fill
        hStackView.alignment = .center
        hStackView.addArrangedSubview(totalAmountLabel)
        hStackView.addArrangedSubview(wonLabel)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(totalTitle)
        view.addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            totalTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            
            hStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 요일 스택뷰
    private lazy var weekOfDayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        let weekOfDay: [String] = ["일", "월", "화", "수", "목", "금", "토"]
        
        for day in weekOfDay {
            let weekLabel = UILabel()
            weekLabel.text = day
            weekLabel.textAlignment = .center
            
            if day == "일" {
                weekLabel.textColor = .red
            }else if day == "토" {
                weekLabel.textColor = .blue
            }
            
            stackView.addArrangedSubview(weekLabel)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(calendarView)
        view.addSubview(inComeAmountView)
        view.addSubview(expenseAmountView)
        view.addSubview(totalAmountView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            calendarView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),
            
            inComeAmountView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
            inComeAmountView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            inComeAmountView.trailingAnchor.constraint(equalTo: calendarView.centerXAnchor, constant: -5),
            inComeAmountView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            expenseAmountView.topAnchor.constraint(equalTo: inComeAmountView.topAnchor),
            expenseAmountView.leadingAnchor.constraint(equalTo: calendarView.centerXAnchor, constant: 5),
            expenseAmountView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            expenseAmountView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            totalAmountView.topAnchor.constraint(equalTo: expenseAmountView.bottomAnchor, constant: 10),
            totalAmountView.leadingAnchor.constraint(equalTo: inComeAmountView.leadingAnchor),
            totalAmountView.trailingAnchor.constraint(equalTo: expenseAmountView.trailingAnchor),
            totalAmountView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            totalAmountView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)

        ])
        
    }
    

}

