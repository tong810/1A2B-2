//
//  ViewController.swift
//  1A2B
//
//  Created by 陳曉潼 on 2024/10/12.
//

import UIKit
import GameKit

class ViewController: UIViewController {
    // 輸入數字按鈕出來的文字Label
    @IBOutlet var numberLabel: [UILabel]!
    // 輸入數字按鈕會跟的文字一起出來的圖片Image
    @IBOutlet var monsterImage: [UIImageView]!
    // 數字鍵的Button
    @IBOutlet var numberButtons: [UIButton]!
    // 刪除數字Button
    @IBOutlet var cancleButton: UIButton!
    // 輸入數字Button
    @IBOutlet var checkAnswerButton: UIButton!
    // 顯示答案Button
    @IBOutlet var showAnswerButton: UIButton!
    // 滿滿的愛心能量
    @IBOutlet var fullHeart: [UIImageView]!
    // 失去的能量愛心
    @IBOutlet var lossHeart: [UIImageView]!
    // 顯示輸入數字與?A?B
    @IBOutlet var recordTextView: UITextView!
    // 當前已輸入數字順序
    var currentIndex = 0
    // 宣告答案數字字串
    var answerNumber = ["","","",""]
    // 放紀錄?A?B字串
    var resultString: String = ""
    // 能量愛心的數量 一開始是10顆心
    var energyHeartIndex = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 預設四個小怪獸圖片一開始為隱藏
        let imageViews: [UIImageView] = monsterImage
        for imageView in imageViews {
            imageView.isHidden = true
        }
        // 預設失去能量的愛心一開始為隱藏
        let imageViews2: [UIImageView] = lossHeart
        for imageView in imageViews2 {
            imageView.isHidden = true
        }
        // 預設textView剛開始進入值
        recordTextView.text = "請按game start\n開始遊戲!!\n\n您有10次機會\n請好好加油!"
        // 預設關閉所有按鈕 只有按了開始遊戲才能玩
        let numberButtons: [UIButton] = self.numberButtons
        for numberButton in numberButtons {
            numberButton.isEnabled = false
        }
        cancleButton.isEnabled = false
        checkAnswerButton.isEnabled = false
        showAnswerButton.isEnabled = false
    }
    
    // 產生亂數
    func answer() {
        // 使用GKShuffledDistribution時要先 import GameplayKit
        let randomNumber = GKShuffledDistribution(lowestValue: 0, highestValue: 9)
        // 將四個隨機數字帶入anumberNumber字串內
        for i in 0...3{
            answerNumber[i] = "\(randomNumber.nextInt())"
            print(answerNumber)
        }
    }
    @IBAction func numberInput(_ sender: UIButton) {
        // 如果順序小於4就不能輸入了 最多4個數字
        if currentIndex < 4 {
            // 將sender.tag帶入numberLabel當前位置的值
            numberLabel[currentIndex].text = String(sender.tag)
            // 數字按鈕就不能按了
            sender.isEnabled = false
            // 當前數字順序的圖片顯示
            let imageViews: [UIImageView] = monsterImage
            imageViews[currentIndex].isHidden = false
            currentIndex += 1
        }
    }
    
    @IBAction func cancelNumber(_ sender: Any) {
        // 如果現在位置大於0才可以按 表示有按數字
        if currentIndex > 0 {
            currentIndex -= 1
            // 先宣告number帶出numberLabel的數字
            let number = Int(numberLabel[currentIndex].text!)
            // 因為numberButtons裡有很多的button所以要找出number的數字
            // 比如number是3 這樣會找出3 button然後再把它enabled
            for numberTag in numberButtons {
                if numberTag.tag == number {
                    numberTag.isEnabled = true
                }
            }
            // 清除numberLabel現在的值
            numberLabel[currentIndex].text = ""
            // 讓現在的小怪獸圖隱藏
            let imageViews: [UIImageView] = monsterImage
            imageViews[currentIndex].isHidden = true
        }
    }
    @IBAction func gameStar(_ sender: UIButton) {
        // 遊戲開始時先產生亂數
        answer()
        currentIndex = 0
        for i in 0...3 {
            numberLabel[i].text = ""
        }
        // 四個小怪獸圖片為隱藏
        let imageViews: [UIImageView] = monsterImage
        for imageView in imageViews {
            imageView.isHidden = true
        }
        // 失去能量的愛心為隱藏
        let imageViews2: [UIImageView] = lossHeart
        for imageView in imageViews2 {
            imageView.isHidden = true
        }
        // 能量的愛心為顯示
        let imageViews3: [UIImageView] = fullHeart
        for imageView in imageViews3 {
            imageView.isHidden = false
        }
        // 打開所有按鈕
        let numberButtons: [UIButton] = self.numberButtons
        for numberButton in numberButtons {
            numberButton.isEnabled = true
        }
        cancleButton.isEnabled = true
        checkAnswerButton.isEnabled = true
        showAnswerButton.isEnabled = true
        // 顯示紀錄清空
        resultString = ""
        recordTextView.text = ""
        // 愛心能量恢復預設值
        energyHeartIndex = 10
    }
    @IBAction func showAnswer(_ sender: Any) {
        // 顯示正確答案
        for i in 0...3{
            numberLabel[i].text = answerNumber[i]
        }
        // 顯示小怪獸圖案
        for i in 0...3{
            let imageViews: [UIImageView] = monsterImage
            imageViews[i].isHidden = false
        }
        // 關閉所有按鈕
        let numberButtons: [UIButton] = self.numberButtons
        for numberButton in numberButtons {
            numberButton.isEnabled = false
        }
        cancleButton.isEnabled = false
        checkAnswerButton.isEnabled = false
        showAnswerButton.isEnabled = false
    }
    @IBAction func checkAnswer(_ sender: UIButton) {
        // 沒填滿四個數字就不能按
        if numberLabel[3].text == ""{return}
        
        // 如果猜的數字等於答案(位置相同透過迴圈比較array每一個數字位置) a+1
        var a: Int = 0
        // 如果猜的數字跟答案數字沒有在相同位置再比較有包含在內 b+1
        var b: Int = 0
        for i in 0...3 {
            if numberLabel[i].text == answerNumber[i] {
                a += 1
            }else if answerNumber.contains(numberLabel[i].text!) {
                b += 1
            }
        }
        
        // 在textView顯示判斷結果
        var userNumberString: String = ""
        for i in 0...3 {
            userNumberString += numberLabel[i].text!
        }
        resultString += "\(userNumberString) \(a)A\(b)B\n"
        recordTextView.text = resultString
        // 把滿滿的愛心隱藏
        fullHeart[energyHeartIndex-1].isHidden = true

        // 判斷遊戲是否結束
        if a == 4 {
            recordTextView.text += "噹噹!中了大獎!\n按game star再玩一次!"
            // 關閉所有按鈕
            let numberButtons: [UIButton] = self.numberButtons
            for numberButton in numberButtons {
                numberButton.isEnabled = false
            }
            cancleButton.isEnabled = false
            checkAnswerButton.isEnabled = false
            showAnswerButton.isEnabled = false
        }   // 如果愛心數等於1的時候再按一次會等於0了
            // 所以等於1的時候還沒有對 就沒有機會再按了
            else if energyHeartIndex == 1 {
                recordTextView.text += "沒有機會了!\n答案是\(answerNumber[0])\(answerNumber[1])\(answerNumber[2])\(answerNumber[3])!!\n按game star再玩一次!"
            // 關閉所有按鈕
            let numberButtons: [UIButton] = self.numberButtons
            for numberButton in numberButtons {
                numberButton.isEnabled = false
            }
            cancleButton.isEnabled = false
            checkAnswerButton.isEnabled = false
            showAnswerButton.isEnabled = false
            // 顯示破碎的愛心
            lossHeart[energyHeartIndex-1].isHidden = false
        }else {
            // 四個小怪獸圖片為隱藏
            let imageViews: [UIImageView] = monsterImage
            for imageView in imageViews {
                imageView.isHidden = true
            }
            // 打開所有按鈕
            let numberButtons: [UIButton] = self.numberButtons
            for numberButton in numberButtons {
                numberButton.isEnabled = true
            }
            // 清除答案數字
            for i in 0...3 {
                numberLabel[i].text = ""
            }
            // 當前字串位置變成0
            currentIndex = 0
            // 顯示破碎的愛心
            lossHeart[energyHeartIndex-1].isHidden = false
        }
        // 愛心能量-1
        energyHeartIndex -= 1
        // 測試使用
        print(energyHeartIndex)
    }
}
