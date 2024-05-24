//
//  CalendarViewController.swift
//  BinPocket
//
//  Created by 조성빈 on 5/17/24.
//

import UIKit

class CalendarViewController: UIViewController {
    
    // 달력 컨테이너 시작
    private var calendarCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var prevMonthButton: UIButton = UIButton()
    private var currentYearMonth: UILabel = UILabel()
    private var nextMonthButton: UIButton = UIButton()
    private var todayButton: UIButton = UIButton()
    private lazy var calendarNavigationBarStackView: UIStackView = UIStackView()
    private lazy var calendarView: UIView = UIView()
    // 달력 컨테이너 끝
    


    // 수입 View
    private lazy var inComeAmountLabel: UILabel = UILabel()
    private lazy var inComeAmountView: UIView = UIView()
    
    // 지출 View
    private lazy var expenseAmountLabel: UILabel = UILabel()
    private lazy var expenseAmountView: UIView = UIView()

    // Total View
    private lazy var totalAmountView: UIView = UIView()
    
    // 요일 스택뷰
    private lazy var weekOfDayStackView: UIStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCalendarNavBarStackView()
        setupTodayButton()
        setupWeekOfDayStackView()
        setupCalendarView()
        setupInComeAmountView()
        setupExpenseAmountView()
        setupTotalAmountView()

    }
    
    // UI 레이아웃 메소드
    func setupCalendarNavBarStackView() {
        prevMonthButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        currentYearMonth.text = "yyyy년 mm월"
        nextMonthButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        
        calendarNavigationBarStackView.axis = .horizontal
        calendarNavigationBarStackView.alignment = .center
        calendarNavigationBarStackView.distribution = .fill
        calendarNavigationBarStackView.spacing = 10
        
        calendarNavigationBarStackView.translatesAutoresizingMaskIntoConstraints = false
        calendarNavigationBarStackView.addArrangedSubview(prevMonthButton)
        calendarNavigationBarStackView.addArrangedSubview(currentYearMonth)
        calendarNavigationBarStackView.addArrangedSubview(nextMonthButton)
        
        calendarView.addSubview(calendarNavigationBarStackView)
        
        NSLayoutConstraint.activate([
            calendarNavigationBarStackView.topAnchor.constraint(equalTo: calendarView.topAnchor, constant: 10),
            calendarNavigationBarStackView.centerXAnchor.constraint(equalTo: calendarView.centerXAnchor),
        ])
    }
    
    
    func setupTodayButton() {
        todayButton.setTitleColor(.white, for: .normal)
        var config = UIButton.Configuration.filled()
        config.title = "Today"
        config.background.backgroundColor = .black
        todayButton.configuration = config
        todayButton.addAction(UIAction { _ in
            print("Clicked Today Button.")
        }, for: .touchUpInside)
        
        todayButton.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.addSubview(todayButton)
        
        NSLayoutConstraint.activate([
            todayButton.centerYAnchor.constraint(equalTo: calendarNavigationBarStackView.centerYAnchor),
            todayButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: -5),
        ])
    }
    
    func setupWeekOfDayStackView() {
        weekOfDayStackView.axis = .horizontal
        weekOfDayStackView.distribution = .fillEqually
        weekOfDayStackView.alignment = .center
        
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
            
            weekOfDayStackView.addArrangedSubview(weekLabel)
        }
        
        weekOfDayStackView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.addSubview(weekOfDayStackView)
        
        NSLayoutConstraint.activate([
            weekOfDayStackView.topAnchor.constraint(equalTo: todayButton.bottomAnchor, constant: 10),
            weekOfDayStackView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            weekOfDayStackView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor)
        ])
    }
    
    func setupCalendarView() {
        calendarView.backgroundColor = .yellow
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        // 임시 콜렉션뷰
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        
        calendarCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        calendarCollectionView.backgroundColor = .lightGray
        
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.addSubview(calendarCollectionView)
        
        NSLayoutConstraint.activate([
            calendarCollectionView.topAnchor.constraint(equalTo: weekOfDayStackView.bottomAnchor, constant: 5),
            calendarCollectionView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            calendarCollectionView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            calendarCollectionView.bottomAnchor.constraint(equalTo: calendarView.bottomAnchor)
        ])
        //
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            calendarView.heightAnchor.constraint(greaterThanOrEqualToConstant: 700)
        ])
    }
    
    func setupInComeAmountView() {
        inComeAmountLabel.text = "0"
        
        inComeAmountView.backgroundColor = .green
        
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
        
        inComeAmountView.addSubview(inComeTitle)
        inComeAmountView.addSubview(hStackView)
        
        // inComeAmountView의 내부 레이아웃
        NSLayoutConstraint.activate([
            inComeTitle.centerXAnchor.constraint(equalTo: inComeAmountView.centerXAnchor),
            inComeTitle.topAnchor.constraint(equalTo: inComeAmountView.topAnchor, constant: 5),
            
            hStackView.centerXAnchor.constraint(equalTo: inComeAmountView.centerXAnchor),
            hStackView.centerYAnchor.constraint(equalTo: inComeAmountView.centerYAnchor),
        ])
        
        inComeAmountView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(inComeAmountView)
        
        // inComeAmountView의 자체 레이아웃
        NSLayoutConstraint.activate([
            inComeAmountView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
            inComeAmountView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            inComeAmountView.trailingAnchor.constraint(equalTo: calendarView.centerXAnchor, constant: -5),
            inComeAmountView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
        ])
    }

    func setupExpenseAmountView() {
        expenseAmountLabel.text = "0"
        
        expenseAmountView.backgroundColor = .green
        
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
        
        expenseAmountView.addSubview(expenseTitle)
        expenseAmountView.addSubview(hStackView)
        
        // inComeAmountView의 내부 레이아웃
        NSLayoutConstraint.activate([
            expenseTitle.centerXAnchor.constraint(equalTo: expenseAmountView.centerXAnchor),
            expenseTitle.topAnchor.constraint(equalTo: expenseAmountView.topAnchor, constant: 5),
            
            hStackView.centerXAnchor.constraint(equalTo: expenseAmountView.centerXAnchor),
            hStackView.centerYAnchor.constraint(equalTo: expenseAmountView.centerYAnchor),
        ])
        
        expenseAmountView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(expenseAmountView)
        
        // inComeAmountView의 자체 레이아웃
        NSLayoutConstraint.activate([
            expenseAmountView.topAnchor.constraint(equalTo: inComeAmountView.topAnchor),
            expenseAmountView.leadingAnchor.constraint(equalTo: calendarView.centerXAnchor, constant: 5),
            expenseAmountView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            expenseAmountView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
        ])
    }

    func setupTotalAmountView() {
        totalAmountView.backgroundColor = .lightGray
        
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
        
        totalAmountView.addSubview(totalTitle)
        totalAmountView.addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            totalTitle.centerXAnchor.constraint(equalTo: totalAmountView.centerXAnchor),
            totalTitle.topAnchor.constraint(equalTo: totalAmountView.topAnchor, constant: 5),
            
            hStackView.centerXAnchor.constraint(equalTo: totalAmountView.centerXAnchor),
            hStackView.centerYAnchor.constraint(equalTo: totalAmountView.centerYAnchor),
        ])
        
        totalAmountView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(totalAmountView)
        
        NSLayoutConstraint.activate([
            totalAmountView.topAnchor.constraint(equalTo: expenseAmountView.bottomAnchor, constant: 10),
            totalAmountView.leadingAnchor.constraint(equalTo: inComeAmountView.leadingAnchor),
            totalAmountView.trailingAnchor.constraint(equalTo: expenseAmountView.trailingAnchor),
            totalAmountView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            totalAmountView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegateFlowLayout
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        .zero
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero // 열 간의 간격을 0으로 설정
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calendarView.frame.width / 7
        return CGSize(width: width, height: width * 1)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCollectionViewCell
        cell.configureCell()
        cell.backgroundColor = .brown
        return cell
    }
    
    
}
