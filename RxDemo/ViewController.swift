//
//  ViewController.swift
//  RxDemo
//
//  Created by admin on 03/06/23.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var count = 0
    var disposeBag = DisposeBag()
    
    private lazy var button: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Push", for: .normal)
        b.backgroundColor = .systemBlue
        b.layer.cornerRadius = 10
        b.titleColor(for: .highlighted)
        return b
    }()
    
    lazy var publishSubjectButton = CustomButton(textButton: "Publish")
    lazy var behaviorSubjectButton = CustomButton(textButton: "Behavior")
    lazy var relaySubjectButton = CustomButton(textButton: "Relay")
    lazy var asyncSubjectButton = CustomButton(textButton: "Async")
    
    
    private lazy var labelCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(count)"
        label.textColor = .black
        return label
    }()
    
    private lazy var labelCountTwo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(count)"
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        publishSubjectButton.tapButton = { [unowned self] in
            self.test(publishSubject, count: 2)
        }
        
        behaviorSubjectButton.tapButton = { [unowned self] in
            self.test(self.behaviorSubject, count: 2)
        }
        
        relaySubjectButton.tapButton = { [unowned self] in
            self.test(self.replaySubject, count: 5)
        }
        
        asyncSubjectButton.tapButton = { [unowned self] in
            self.test(asyncSubject, count: 3)
        }
        let plainObservable = Observable<Int>.just(count)
        // deferred - вернет значение переменной count только в момент обращения к ней
        let defferObservable = Observable.deferred{ return Observable<Int>.just(self.count)}
//        self.count += 1
        
///        RXButton
        button.rx
            .tap
            .throttle(DispatchTimeInterval.seconds(1) , scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.count += 1
                self?.labelCount.text = "\(self?.count ?? 0)"
            })

            .disposed(by: disposeBag)
    }

    func test<T>(_ subject: T, count: Int) where T: SubjectType {
        var subscriptionResult = [String]()
        
        for i in (0...count) {
            subscriptionResult.append("--")
            
            subject
                .subscribe(onNext: { value in
                    subscriptionResult[i] += "\(value) --"
                },
                onCompleted: {
                    print("\(subject.self)Subscription\(i): \(subscriptionResult[i])>")
                    
                })
                .disposed(by: disposeBag)
            subject.asObserver().onNext(i as! T.Observer.Element)
        }
        subject.asObserver().onCompleted()
    }

    // PublishSubject - создается пустым и транслирует подписчикам только новые значения
    let publishSubject = PublishSubject<Int>()
    
    // BehaviorSubject - создается с неким изначальным значением и ретранслирует(а далее последнее полученное значение) подписчикам
    let behaviorSubject = BehaviorSubject<Int>(value: 0)
    
    // RelaySubject - инициализируется с некоторым размером буфера, все элементы, входящие в этот буфер, будут ретранслированы подписчикам
    let replaySubject = ReplaySubject<Int>.create(bufferSize: 2)
    
    // AsyncSubject - хранит текущее значение и ретранслирует его подписчикам
    let asyncSubject = AsyncSubject<Int>()
    
    func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(button)
        self.view.addSubview(labelCount)
        self.view.addSubview(labelCountTwo)
        self.view.addSubview(publishSubjectButton)
        self.view.addSubview(behaviorSubjectButton)
        self.view.addSubview(relaySubjectButton)
        self.view.addSubview(asyncSubjectButton)
        
        NSLayoutConstraint.activate([
        
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 150),
            
            labelCount.bottomAnchor.constraint(equalTo: self.button.topAnchor, constant: -20),
            labelCount.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            labelCountTwo.topAnchor.constraint(equalTo: self.button.bottomAnchor, constant: 20),
            labelCountTwo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            publishSubjectButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            publishSubjectButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            publishSubjectButton.heightAnchor.constraint(equalToConstant: 40),
            publishSubjectButton.widthAnchor.constraint(equalToConstant: 150),
            
            behaviorSubjectButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            behaviorSubjectButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            behaviorSubjectButton.heightAnchor.constraint(equalToConstant: 40),
            behaviorSubjectButton.widthAnchor.constraint(equalToConstant: 150),
        
            relaySubjectButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            relaySubjectButton.topAnchor.constraint(equalTo: self.publishSubjectButton.bottomAnchor, constant: 30),
            relaySubjectButton.heightAnchor.constraint(equalToConstant: 40),
            relaySubjectButton.widthAnchor.constraint(equalToConstant: 150),
        
            asyncSubjectButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            asyncSubjectButton.centerYAnchor.constraint(equalTo: self.relaySubjectButton.centerYAnchor),
            asyncSubjectButton.heightAnchor.constraint(equalToConstant: 40),
            asyncSubjectButton.widthAnchor.constraint(equalToConstant: 150),
            
        ])
    }
    
}

