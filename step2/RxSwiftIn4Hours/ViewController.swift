//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class ViewController: UITableViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func exJust1() {
        Observable.from(["RxSwift", "In", 4, "Hours"])
            //.single()
            .subscribe { s in
                print(s)
            } onError: { err in
                print(err.localizedDescription)
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)

    }

    @IBAction func exJust2() {
        Observable.just(["Hello", "World"])
            .subscribe(onNext: { arr in
                print(arr)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFrom1() {
        Observable.from(["RxSwift", "In", "4", "Hours"])
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap1() {
        Observable.just("Hello")
            .map { str in "\(str) RxSwift" }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap2() {
        Observable.from(["with", "곰튀김"])
            .map { $0.count }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFilter() {
        Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .filter { $0 % 2 == 0 }
            .subscribe(onNext: { n in
                print(n)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap3() {
        Observable.just("800x600")
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default)) //qos는 우선순위
            .map { $0.replacingOccurrences(of: "x", with: "/") } // 800/600
            .map { "https://picsum.photos/\($0)/?random" } //"https://picsum.photos/800/600/?random"
            .map { URL(string: $0) } //URL?
            
            .filter { $0 != nil } //객체가 nil이면 false, true면 내려감
            .map { $0! } //강제 unwrapping , URL!
            .map { try Data(contentsOf: $0) } //Data가 내려옴
            .map { UIImage(data: $0) } //Data -> Image로
            .observeOn(MainScheduler.instance )
            //위에 스트림이 지나가는 동안에 한번 실행하고 진행된다.
            .do(onNext: { image in
                print(image?.size)
            })
            .subscribe(onNext: { image in
                self.imageView.image = image //이미지로 세팅
            })
            .disposed(by: disposeBag)
    }
}
