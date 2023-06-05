//
//  OperatorsViewController.swift
//  RxDemo
//
//  Created by admin on 05/06/23.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift


class OperatorsViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Фильтрующие операторы"
        label.textColor = .black
        return label
    }()
    
    private lazy var transformLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трансформирующие операторы"
        label.textColor = .black
        return label
    }()
    
    private lazy var combineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Комбинирующие операторы"
        label.textColor = .black
        return label
    }()
    
    private lazy var filterStackView: UIStackView = {
       let sView = UIStackView()
        sView.translatesAutoresizingMaskIntoConstraints = false
        sView.axis = .vertical
        sView.spacing = 16
        sView.distribution = .fillEqually
        return sView
    }()
    
    // Кнопки фильтрующих операторов
    lazy var elementAtButton = CustomButton(textButton: "elementAt", color: .systemBlue)
    lazy var filterButton = CustomButton(textButton: "filter", color: .systemBlue)
    lazy var skipButton = CustomButton(textButton: "skip", color: .systemBlue)
    lazy var takeButton = CustomButton(textButton: "take", color: .systemBlue)
    lazy var distinctUntilChangeButton = CustomButton(textButton: "distinctUntil", color: .systemBlue)
    
    // Кнопки трансформирующих операторов
    lazy var mapButton = CustomButton(textButton: "map", color: .systemBlue)
    lazy var reduceButton = CustomButton(textButton: "reduce", color: .systemBlue)
    
    // Кнопки комбинирующих операторов
    lazy var mergeButton = CustomButton(textButton: "merge", color: .systemBlue)
    lazy var concatButton = CustomButton(textButton: "concat", color: .systemBlue)
    lazy var combineLatestButton = CustomButton(textButton: "combineLatest", color: .systemBlue)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVew()
        self.navigationItem.title = "Операторы"
        let elements = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let observable = Observable.from(elements)
        let elementsToDistinct = [0, 1, 1, 1, 2, 2, 1, 1,]
        let distinctObservable = Observable.from(elementsToDistinct)
        /// Фильтрующие
        // elementAt - выведет первый параметр
        elementAtButton.tapButton = { [unowned self] in
            self.example(of: "elementAt", observable.element(at: 1))
        }
        // filter - фильтрует по заданныым параметрам
        filterButton.tapButton = { [unowned self] in
            self.example(of: "filter", observable.filter({$0 % 2 == 0}))
        }
        // skip - позволяет пропустить заданное количество последовательностей
        skipButton.tapButton = { [unowned self] in
            self.example(of: "skip", observable.skip(3))
        }
        // take - оставляет заданное количество элементов из последовательности (!skip)
        takeButton.tapButton = { [unowned self] in
            self.example(of: "take", observable.take(3))
        }
        // distinctUntilChange - игнорирует дублирующие элементы пока не придет отличный от других элемент
        distinctUntilChangeButton.tapButton = { [unowned self] in
            self.example(of: "distinctUntilChange", distinctObservable.distinctUntilChanged())
        }
        /// Трансформирующие
        // map - аналогичен map в swift
        mapButton.tapButton = { [unowned self] in
            self.example(of: "map", observable.map({$0 * 10}))
        }
        // reduce == reduce swift
        reduceButton.tapButton = { [unowned self] in
            self.example(of: "reduce", observable.reduce(0, accumulator: +))
        }
        
        /// Комбинирующие
        // merge - объединяет элементы нескольких последовательностей
        mergeButton.tapButton = { [unowned self] in
            self.example(of: "merge", Observable.merge(observable, distinctObservable))
        }
        // concat - склеивает заданные последовательности в одну при условии что они завершились успешно
        concatButton.tapButton = { [unowned self] in
            self.example(of: "concat", Observable.concat(observable, distinctObservable))
        }
        // combineLatest - объединяет две последовательности, применяя функции для преобразования
        combineLatestButton.tapButton = { [unowned self] in
            self.example(of: "combineLatest", Observable.combineLatest(observable, distinctObservable, resultSelector: {$0 * $1}))
        }
    }
    
    private func setupVew() {
        self.view.backgroundColor = .white
        self.view.addSubview(filterStackView)
        self.view.addSubview(filterLabel)
        self.view.addSubview(elementAtButton)
        self.view.addSubview(filterButton)
        self.view.addSubview(skipButton)
        self.view.addSubview(takeButton)
        self.view.addSubview(distinctUntilChangeButton)
        self.view.addSubview(mapButton)
        self.view.addSubview(reduceButton)
        self.view.addSubview(transformLabel)
        self.view.addSubview(combineLabel)
        self.view.addSubview(mergeButton)
        self.view.addSubview(concatButton)
        self.view.addSubview(combineLatestButton)

        
        filterLabel.snp.makeConstraints({ v in
            v.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            v.centerX.equalTo(self.view.snp.centerX)
        })
        
        elementAtButton.snp.makeConstraints({ b in
            b.top.equalTo(filterLabel.snp.bottom).offset(16)
            b.left.equalToSuperview().offset(16)
            b.width.equalTo(150)
            b.height.equalTo(40)
            
        })
        
        filterButton.snp.makeConstraints({ b in
            b.top.equalTo(filterLabel.snp.bottom).offset(16)
            b.right.equalToSuperview().inset(16)
            b.width.equalTo(150)
            b.height.equalTo(40)
            
        })
        
        skipButton.snp.makeConstraints({ b in
            b.top.equalTo(elementAtButton.snp.bottom).offset(16)
            b.left.equalToSuperview().offset(16)
            b.width.equalTo(150)
            b.height.equalTo(40)
            
        })
        
        takeButton.snp.makeConstraints({ b in
            b.top.equalTo(elementAtButton.snp.bottom).offset(16)
            b.right.equalToSuperview().inset(16)
            b.width.equalTo(150)
            b.height.equalTo(40)
            
        })
        
        distinctUntilChangeButton.snp.makeConstraints({ b in
            b.top.equalTo(takeButton.snp.bottom).offset(16)
            b.centerX.equalToSuperview()
            b.width.equalTo(150)
            b.height.equalTo(40)
            
        })
        
        transformLabel.snp.makeConstraints({ v in
            v.top.equalTo(self.distinctUntilChangeButton.snp.bottom).offset(20)
            v.centerX.equalTo(self.view.snp.centerX)
        })
        
        mapButton.snp.makeConstraints({ m in
            m.top.equalTo(self.transformLabel.snp.bottom).offset(16)
            m.left.equalToSuperview().offset(16)
            m.width.equalTo(150)
            m.height.equalTo(40)
        })
        
        reduceButton.snp.makeConstraints({ m in
            m.top.equalTo(self.transformLabel.snp.bottom).offset(16)
            m.right.equalToSuperview().inset(16)
            m.width.equalTo(150)
            m.height.equalTo(40)
        })
        
        combineLabel.snp.makeConstraints({ m in
            m.top.equalTo(self.reduceButton.snp.bottom).offset(20)
            m.centerX.equalTo(self.view.snp.centerX)
        })
        
        mergeButton.snp.makeConstraints({ m in
            m.top.equalTo(self.combineLabel.snp.bottom).offset(16)
            m.left.equalToSuperview().offset(16)
            m.width.equalTo(150)
            m.height.equalTo(40)
        })
        
        concatButton.snp.makeConstraints({ m in
            m.top.equalTo(self.combineLabel.snp.bottom).offset(16)
            m.right.equalToSuperview().inset(16)
            m.width.equalTo(150)
            m.height.equalTo(40)
        })
        
        combineLatestButton.snp.makeConstraints({ b in
            b.top.equalTo(concatButton.snp.bottom).offset(16)
            b.centerX.equalToSuperview()
            b.width.equalTo(150)
            b.height.equalTo(40)
            
        })
    }
   
    func example<T>(of name: String, _ observable: T) where T: ObservableType, T.Element == Int {
        var subscriptionResult = "--"
        
        observable
            .subscribe(onNext: { value in
                subscriptionResult += " \(value) --"
            },
            
            onCompleted: {
                print("\(name) | \(subscriptionResult)>")
            })
            .disposed(by: disposeBag)
    }

    
    
}
