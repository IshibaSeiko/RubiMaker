# RubiMaker
入力したテキストのルビを生成するアプリです。

## 開発環境
Xcode 11.4
サポートOS iOS 13.0
サポート端末

## Library
ライブラリはSwiftPMによって導入しています。
- 通信
  - Alamofire
    API通信に使用
- ネットワーク監視
  - Reachability
    現在使用していないが、今後の機能拡充のためにインストール済み
- データベース
  - Realm
    履歴保存のために使用
- ログ
  - XCGLogger
    デバッグ時のログ表示のため使用
- UI
  - FloatingPanel
    入力画面表示のために使用
  - GrowingTextView
    テキストビューのデザインを実現するために使用

## 工夫した点
- APIで定義されたエラーを網羅するように実装
- 直感的に操作できるUI
-# RubiMaker
入力したテキストのルビを生成するアプリです。

## 開発環境
Xcode 11.4
サポートOS iOS 13.0
サポート端末

## Library
ライブラリはSwiftPMによって導入しています。
- 通信
  - Alamofire
    API通信に使用
- ネットワーク監視
  - Reachability
    現在使用していないが、今後の機能拡充のためにインストール済み
- データベース
  - Realm
    履歴保存のために使用
- ログ
  - XCGLogger
    デバッグ時のログ表示のため使用
- UI
  - FloatingPanel
    入力画面表示のために使用
  - GrowingTextView
    テキストビューのデザインを実現するために使用

## 工夫した点
- APIで定義されたエラーを網羅するように実装
- 直感的に操作できるUI
- 過去の履歴の一覧表示
