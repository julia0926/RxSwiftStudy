//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    // MARK: - Bind UI

    private func bindUI() {
        // id input +--> check valid --> bullet
        //          |
        //          +--> button enable
        //          |
        // pw input +--> check valid --> bullet
        
        
        //rx로 하면
        idField.rx.text.orEmpty //orEmpty가 밑에 두줄과 동일함
//            .filter { $0 != nil}
//            .map { $0! }
            .map(checkEmailValid)
            .subscribe(onNext: { b in
                self.idValidView.isHidden = b
            })
        .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .map(checkPasswordValid)
            .subscribe(onNext: { s in
                self.pwValidView.isHidden = s
            })
        .disposed(by: disposeBag)
        
        
        // 가장 최근에 전달했던 값을 내려보내서 전달
        Observable.combineLatest( //두개의 스트림을 받아서
            idField.rx.text.orEmpty.map(checkEmailValid),
            pwField.rx.text.orEmpty.map(checkPasswordValid),
            resultSelector: { s1, s2 in s1 && s2 } //여기서 결정된 불린 값으로
        ) // 밑에 줄이 실행됨
            .subscribe(onNext: { s in
                self.loginButton.isEnabled = s
            })
            .disposed(by: disposeBag)
    
    }
    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
