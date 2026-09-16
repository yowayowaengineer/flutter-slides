# flutter-slides

よわよわエンジニアの Flutter 登壇資料モノレポ。
[flutter_deck](https://pub.dev/packages/flutter_deck) ベースの登壇資料を、共通部品を使い回しながら量産するためのリポジトリ。

## 構成

```
flutter-slides/
├── packages/
│   └── slide_kit/        # 共通部品パッケージ（テーマ / 歩くフッター / 自己紹介 / App スキャフォールド）
└── talks/
    └── _template/        # 登壇テンプレート。新しい登壇はこれをコピーして作る
```

- **Flutter**: 3.44.1（fvm で固定 / `.fvmrc`）
- **モノレポ管理**: [melos](https://melos.invertase.dev/) + Dart pub workspaces

## セットアップ

```bash
# Flutter バージョンを合わせる
fvm install

# melos を有効化（初回のみ）
fvm dart pub global activate melos

# 依存解決（pub workspace で全パッケージ一括）
fvm dart pub get
```

## よく使うコマンド

```bash
# 登壇を起動（web）
cd talks/_template
fvm flutter run -d chrome

# 全体を解析 / テスト / フォーマット
fvm dart run melos run analyze
fvm dart run melos run test
fvm dart run melos run format
```

## 新しい登壇の作り方

1. `talks/_template` を `talks/<talk_name>` にコピー
2. `pubspec.yaml` の `name` を変更（例: `flutter_kaigi_2026`）
3. ルート `pubspec.yaml` の `workspace:` に新しい登壇を追記
4. `fvm dart pub get` で再解決
5. `lib/slides/` の中身を書いていく（共通部品は `package:slide_kit` から利用）
