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
    
    let idValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let idInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let pwInputText: BehaviorSubject<String> = BehaviorSubject(value: "")


    override func viewDidLoad() {
        super.viewDidLoad()
        bindInput()
        bindOutput()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    
    
    // MARK: - Bind Input

    // id input +--> check valid --> bullet
    //          |
    //          +--> button enable
    //          |
    // pw input +--> check valid --> bullet
    
    
    
    private func bindInput() {
       
//2. 1번과 동일하지만 짧은 코드
        
        //input: 아이디, 비번 입력
        idField.rx.text.orEmpty //아이디를 입력받아서
            .bind(to: idInputText) // 텍스트를 저장
            .disposed(by: disposeBag)
        
 //3 : input
        //idField.rx.text.orEmpty 이걸 사용하지 않고 idInputText에서 가져와도 됨, 이어서 사용하므로
        idInputText
            .map(checkEmailValid) //이메일 체크한 결과를
            .bind(to: idValid) //외부의 idValid라는 데이터 스트림에 담음
            .disposed(by: disposeBag)

        pwField.rx.text.orEmpty
            .bind(to: pwInputText)
            .disposed(by: disposeBag)
        
        pwInputText
            .map(checkPasswordValid)
            .bind(to: pwValid)
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Bind Output
    private func bindOutput() {
//3 : output
        idValid.subscribe(onNext: { b in self.idValidView.isHidden = b })
            .disposed(by: disposeBag)
        pwValid.subscribe(onNext: { b in self.pwValidView.isHidden = b })
            .disposed(by: disposeBag)

        Observable.combineLatest(idValid, pwValid, resultSelector: { $0 && $1})
            .subscribe(onNext: { b in self.loginButton.isEnabled = b })
            .disposed(by: disposeBag)
        
//2-1
        //output: bool, 로그인버튼 enable
//        idValidOb.subscribe(onNext: { b in self.idValidView.isHidden = b })
//            .disposed(by: disposeBag)
//        pwValidOb.subscribe(onNext: { b in self.pwValidView.isHidden = b })
//            .disposed(by: disposeBag)
//
//        Observable.combineLatest(idValidOb, pwValidOb, resultSelector: { $0 && $1})
//            .subscribe(onNext: { b in self.loginButton.isEnabled = b })
//            .disposed(by: disposeBag)
//
        
// 1. 처음 시도 코드
//        idField.rx.text.orEmpty //orEmpty가 밑에 두줄과 동일함
////            .filter { $0 != nil}
////            .map { $0! }
//            .map(checkEmailValid)
//            .subscribe(onNext: { b in
//                self.idValidView.isHidden = b
//            })
//        .disposed(by: disposeBag)
//
//        pwField.rx.text.orEmpty
//            .map(checkPasswordValid)
//            .subscribe(onNext: { s in
//                self.pwValidView.isHidden = s
//            })
//        .disposed(by: disposeBag)
//
//
//        // 가장 최근에 전달했던 값을 내려보내서 전달
//        Observable.combineLatest( //두개의 스트림을 받아서
//            idField.rx.text.orEmpty.map(checkEmailValid),
//            pwField.rx.text.orEmpty.map(checkPasswordValid),
//            resultSelector: { s1, s2 in s1 && s2 } //여기서 결정된 불린 값으로
//        ) // 밑에 줄이 실행됨
//            .subscribe(onNext: { s in
//                self.loginButton.isEnabled = s
//            })
//            .disposed(by: disposeBag)
//
    }
    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
