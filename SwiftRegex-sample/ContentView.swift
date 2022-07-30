//
//  ContentView.swift
//  SwiftRegex-sample
//
//  Created by kazunori.aoki on 2022/07/30.
//

import SwiftUI
import RegexBuilder

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .onAppear(perform: onAppear)
    }

    func onAppear() {
//        dateRegex()
//        match()
//        tryCapture()
        backReference()
    }

    func dateRegex() {
//        _ = /\d{4}-\d{2}-\d{2}/ // これと同一
        let regex = Regex {
            Repeat(count: 4) { .digit }
            "-"
            Repeat(count: 2) { .digit }
            "-"
            Repeat(count: 2) { .digit }
        }

        let match = "2022-07-30".wholeMatch(of: regex)
        if let match {
            print(match.0)
        } else {
            print("not match")
        }
    }

    func match() {
        // MARK: リテラルキャプチャ
//        _ = /(\d{4})-(\d{2})-(\d{2})/
//        let regex = Regex {
//            Capture { Repeat(count: 4) { .digit } }
//            "-"
//            Capture { Repeat(count: 2) { .digit } }
//            "-"
//            Capture { Repeat(count: 2) { .digit } }
//        }

        // MARK: 名前付きキャプチャ
//        _ = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/
        let year = Reference(Substring.self)
        let month = Reference(Substring.self)
        let day = Reference(Substring.self)
        let regex = Regex {
            Capture(as: year) { Repeat(count: 4) { .digit } }
            "-"
            Capture(as: month) { Repeat(count: 2) { .digit } }
            "-"
            Capture(as: day) { Repeat(count: 2) { .digit } }
        }

        let match = "2022-07-18".wholeMatch(of: regex)
        if let match {
            print("\(match.1)年\(match.2)月\(match.3)日") // -> 2022年07月18日
        }
    }

    func tryCapture() {
//        let regex = Regex {
//            TryCapture { Repeat(count: 4) { .digit } } transform: { Int($0) }
//            "-"
//            TryCapture { Repeat(count: 2) { .digit } } transform: { Int($0) }
//            "-"
//            TryCapture { Repeat(count: 2) { .digit } } transform: { Int($0) }
//        }

        let year = Reference(Int.self)
        let month = Reference(Int.self)
        let day = Reference(Int.self)
        let regex = Regex {
            TryCapture(as: year) { Repeat(count: 4) { .digit } } transform: { Int($0) }
            "-"
            TryCapture(as: month) { Repeat(count: 2) { .digit } } transform: { Int($0) }
            "-"
            TryCapture(as: day) { Repeat(count: 2) { .digit } } transform: { Int($0) }
        }

        let match = "2022-07-18".wholeMatch(of: regex)
        if let match {
            print("\(match[year])年\(match[month])月\(match[day])日")
        }
    }

    func backReference() {
//        _ = /([a-z]+) \1/
//        _ = = /(?<word>[a-z]+) \k<word>/ // match.wordとアクセスする
        let word = Reference(Substring.self)
        let regex = Regex {
            Capture(as: word) { OneOrMore(/[a-z]/) }
            One(.whitespace)
            Capture(word)
        }

        let match = "the the".wholeMatch(of: regex)
        if let match {
            print(match[word]) // -> the
        }
    }
}

