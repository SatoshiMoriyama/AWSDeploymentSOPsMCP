---
sop_name: deploy-frontend-app
repo_name: nextjsapp-deployment
app_name: NextJSApp
app_type: フロントエンドアプリケーション (Next.js)
branch: deploy-to-aws
created: 2026-02-10T15:30:00+09:00
last_updated: 2026-02-10T15:45:00+09:00
---

# デプロイプラン: NextJSApp

コーディングエージェントはこのデプロイプランに従い、新しいコーディングセッションでデプロイを再開する場合は以前の進捗を検証する必要があります。

**重要**: 各ステップ完了後にこのプランを更新してください。ステップを `[x]` でマークし、`last_updated` タイムスタンプを更新します。

## フェーズ1: コンテキスト収集と設定
- [x] ステップ0: 実行フローの説明
- [x] ステップ1: デプロイプランの作成
- [x] ステップ2: デプロイブランチの作成
- [x] ステップ3: ビルド設定の検出
- [x] ステップ4: 前提条件の検証
- [x] ステップ5: デプロイプランの見直し

### 検出されたビルド設定
- パッケージマネージャー: pnpm v10.20.0
- フレームワーク: Next.js 16.1.6 (App Router)
- ビルドコマンド: `pnpm --filter nextjsapp run build`
- 出力ディレクトリ: `packages/nextjsapp/out/`
- ベースパス: `/` (ルート)
- CloudFront設定: SPA (エラーレスポンスを /index.html へ)

## フェーズ2: CDKインフラストラクチャの構築
- [x] ステップ6: CDK基盤の初期化
- [x] ステップ7: CDKスタックの生成
- [x] ステップ8: デプロイスクリプトの作成
- [x] ステップ9: CDK Synthの検証

## フェーズ3: デプロイと検証
- [x] ステップ10: CDKデプロイの実行
- [x] ステップ11: CloudFormationスタックの検証

## フェーズ4: ドキュメントの更新
- [x] ステップ12: デプロイプランの最終化
- [x] ステップ13: README.mdの更新

## デプロイ情報

- デプロイURL: https://d1thetn4gk5512.cloudfront.net
- スタック名: NextJSAppFrontend-preview-mori
- ディストリビューションID: E1BL2H0W4UZW0R
- S3バケット: nextjsappfrontend-preview-m-cftos3s3bucketcae9f2be-nweitdzndqtx
- CloudFrontログバケット: nextjsappfrontend-preview-cftos3cloudfrontloggingb-1xogatnadyxq
- S3ログバケット: nextjsappfrontend-preview-cftos3s3loggingbucket64b-gl1kpaxixz2f

## リカバリーガイド

```bash
# ロールバック
cd packages/cdk && npx cdk destroy "NextJSAppFrontend-preview-mori" --profile work

# 再デプロイ
./scripts/deploy.sh
```

## 発生した問題

なし

## セッションログ

### セッション1 - 2026-02-10T15:30:00+09:00
エージェント: Auto
進捗: デプロイプラン作成、CDKインフラ設定、AWSへのデプロイ完了
次: ドキュメント完成
