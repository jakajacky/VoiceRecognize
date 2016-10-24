//
//  EchoViewController.swift
//  EchoMessage
//
//  Created by xqzh on 16/10/21.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit

typealias MessageClosure = (_ str:NSString) -> Void

class EchoViewController: UIViewController, IFlyRecognizerViewDelegate {
  
  var _iflyRecognizerView:IFlyRecognizerView!
  
  // 闭包传递文字
  var message:MessageClosure!
  
  // 拼接
  var mes:NSMutableString!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      mes = NSMutableString()
        
      //初始化语音识别控件
      _iflyRecognizerView = IFlyRecognizerView(center: CGPoint(x: 182.5, y: 120))
      _iflyRecognizerView.setParameter("", forKey: IFlySpeechConstant.params())
      _iflyRecognizerView.delegate = self;
      //设置听写模式
      _iflyRecognizerView.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
      //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
      _iflyRecognizerView.setParameter("asrview.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
      self.view.addSubview(_iflyRecognizerView)
      
      //-----------------
      let instance = IATConfig.sharedInstance()
        //设置最长录音时间
      _iflyRecognizerView.setParameter(instance?.speechTimeout, forKey: IFlySpeechConstant.speech_TIMEOUT())
        //设置后端点
      _iflyRecognizerView.setParameter(instance?.vadEos, forKey: IFlySpeechConstant.vad_EOS())
        //设置前端点
      _iflyRecognizerView.setParameter(instance?.vadBos, forKey: IFlySpeechConstant.vad_BOS())
        //网络等待时间
      _iflyRecognizerView.setParameter("20000", forKey: IFlySpeechConstant.net_TIMEOUT())
        
        //设置采样率，推荐使用16K
      _iflyRecognizerView.setParameter(instance?.sampleRate, forKey: IFlySpeechConstant.sample_RATE())
        
        if (instance?.language == IATConfig.chinese()) {
          //设置语言
          _iflyRecognizerView.setParameter(instance?.language, forKey: IFlySpeechConstant.language())
          
          //设置方言
          _iflyRecognizerView.setParameter(instance?.accent, forKey: IFlySpeechConstant.accent())
          
        }else if (instance?.language == IATConfig.english()) {
          //设置语言
          _iflyRecognizerView.setParameter(instance?.language, forKey: IFlySpeechConstant.language())
        }
        //设置是否返回标点符号
      _iflyRecognizerView.setParameter(instance?.dot, forKey: IFlySpeechConstant.asr_PTT())
      
      
      
      
      
      //-----------------
      
      
      //设置音频来源为麦克风
      _iflyRecognizerView.setParameter(IFLY_AUDIO_SOURCE_MIC, forKey: "audio_source")
      
      //设置听写结果格式为json
      _iflyRecognizerView.setParameter("plain", forKey: IFlySpeechConstant.result_TYPE())
      
      //启动识别服务
      _iflyRecognizerView.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension EchoViewController {
  func onResult(_ resultArray: [Any]!, isLast: Bool) {
//    NSMutableString *result = [[NSMutableString alloc] init];
    let result = NSMutableString()
    if (resultArray != nil) {
      let dic = resultArray![0] as! NSDictionary
      for key in dic.allKeys {
        result.appendFormat("%@", key as! CVarArg)
      }
      mes = NSMutableString(format: "%@%@", mes, result)
      
      print("是否是最后一句：\(isLast)")
      if isLast {
        self.message(mes)
      }
    }
    
  }
  
  func onError(_ error: IFlySpeechError!) {
    print("错误信息：\(error.errorDesc)")
    
    self.dismiss(animated: true, completion: {

    })
  }
  
  
}
