//
//  DiaryVM.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/9/24.
//

import Combine

final class DiaryVM: ViewModel {
    
    struct Input {
        let tapRecordEnd: PassthroughSubject<String, Never>
    }
    
    struct Output {
//        let
    }
    
    var recordContent: String?
    
    func transform(input: Input) -> Output {
        
        let recordContent = input.tapRecordEnd
        print("🍎🍎diaryvm🍎🍎")
        print(recordContent)
        
        return Output(
        )
    }
    
}
