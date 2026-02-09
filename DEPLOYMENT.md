# デプロイサマリー

アプリが AWS にデプロイされました！　プレビューURL: https://d1thetn4gk5512.cloudfront.net

**次のステップ: デプロイの自動化**

現在は手動デプロイを使用しています。GitHub からの自動デプロイを設定するには、エージェント SOP を使って AWS CodePipeline をセットアップできます。試してみてください: "AWS SOPs を使ってパイプラインを作成して"

使用サービス: CloudFront, S3, CloudFormation, IAM

質問がある場合は、コーディングエージェントに聞いてください:
 - AWS にどのようなリソースがデプロイされましたか？
 - デプロイを更新するにはどうすればいいですか？

## クイックコマンド

```bash
# デプロイステータスの確認
aws cloudformation describe-stacks --stack-name "NextJSAppFrontend-preview-mori" --query 'Stacks[0].StackStatus' --output text --profile work

# CloudFrontキャッシュの無効化
aws cloudfront create-invalidation --distribution-id "E1BL2H0W4UZW0R" --paths "/*" --profile work

# CloudFrontアクセスログの確認（直近）
aws s3 ls "s3://nextjsappfrontend-preview-cftos3cloudfrontloggingb-1xogatnadyxq/" --recursive --profile work | tail -20

# 再デプロイ
./scripts/deploy.sh
```

## 本番環境への準備

本番環境へのデプロイを検討する際は、以下を考慮してください:
- WAF 保護: AWS WAF にマネージドルール（Core Rule Set、Known Bad Inputs）とレート制限を追加
- CSP ヘッダー: CloudFront レスポンスヘッダーで Content Security Policy を設定（`script-src 'self'`、`frame-ancestors 'none'`）
- カスタムドメイン: Route 53 と ACM 証明書をセットアップ
- モニタリング: 4xx/5xx エラーと CloudFront メトリクスの CloudWatch アラーム
- 認証リダイレクト URL: 認証プロバイダー（Auth0、Supabase、Firebase、Lovable など）を使用している場合は、CloudFront URL を許可されたリダイレクト URL に追加

---


---
sop_name: deploy-frontend-app
repo_name: nextjsapp-deployment
app_name: NextJSApp
app_type: Frontend Application (Next.js)
branch: deploy-to-aws
created: 2026-02-10T15:30:00+09:00
last_updated: 2026-02-10T04:49:00+09:00
---

# デプロイプラン: NextJSApp

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
