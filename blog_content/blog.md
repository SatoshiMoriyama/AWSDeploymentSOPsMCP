# AWS MCP Server を試してみた - 統合MCPサーバーの設定とCloudTrail連携

## はじめに

1/29 の以下のアップデートを追ってみます。

https://aws.amazon.com/jp/about-aws/whats-new/2025/01/aws-announces-deployment-agent-sops-in-aws-mcp-server-preview/

ただ今回は検証をしていく中でそもそも私が、AWS MCP Server を把握できてなかったので、今回は AWS MCP Server そのものを紹介し、次回この SOP（Standard Operating Procedure：標準作業手順書）について記事にしようと思います。

### この記事で学べること

- AWS MCP Server の概要と既存 MCP サーバーとの違い
- AWS MCP Server の設定方法
- 利用可能な 8 つのツール（Agent SOP、AWS Knowledge、AWS API）の機能
- CloudTrail での MCP 操作履歴の確認方法
  - `CallReadWriteTool` と `Initialize` イベントの記録内容

### 前提知識・条件

- `mcp-proxy-for-aws` の実行に uv パッケージマネージャー（および uvx コマンド）のインストールが必要です
- mcp-proxy-for-aws: v1.1.6 で検証しています

## やってみた

最初は AWS 提供の MCP がまた 1 つ増えたのかな？　と思ってたのですが少し違うみたいです。

以前より、AWS MCP Server というのがリリースされている模様で、この MCP に対する機能追加の模様です。

https://aws.amazon.com/jp/about-aws/whats-new/2025/11/aws-mcp-server/

下記ページを見ると、以下のような紹介がされていました。

https://docs.aws.amazon.com/aws-mcp/latest/userguide/what-is-mcp-server.html

> The server handles authentication through standard AWS Identity and Access Management (IAM) controls and provides comprehensive audit logging through AWS CloudTrail.

「AWS CloudTrail を通じて包括的な監査ログを提供します」とあります。

この MCP の操作が CloudTrail に保持される模様ですね、これは便利そう。

> The AWS MCP Server consolidates capabilities from existing MCP servers (AWS Knowledge MCP and AWS API MCP) into a single, unified interface that reduces configuration complexity while improving AI agent effectiveness across multi-service AWS workflows.

既存の MCP サーバー（AWS Knowledge MCP および AWS API MCP）の機能を単一の統合インタフェースに集約してくれる模様です。

### まずは設定してみる

まずは kiro に AWS MCP Server を設定してみます。

```json:.kiro/settings/mcp.json
{
  "mcpServers": {
    "aws-mcp": {
      "command": "uvx",
      "timeout": 100000,
      "transport": "stdio",
      "args": [
        "mcp-proxy-for-aws@latest",
        "https://aws-mcp.us-east-1.api.aws/mcp",
        "--metadata", "AWS_REGION=us-west-2"
      ]
    }
  }
}
```

エラーが出ました。認証情報が必要みたいですね。

```text
botocore.exceptions.LoginRefreshRequired: Your session has expired or credentials have changed. Please reauthenticate using 'aws login'.
```

私の環境ではデフォルトプロファイルを利用していないので、以下のような追加設定をすることで接続できました。

```diff_json:.kiro/settings/mcp.json
{
  "mcpServers": {
    "aws-mcp": {
      "command": "uvx",
      "timeout": 100000,
      "transport": "stdio",
      "args": [
        "mcp-proxy-for-aws@latest",
        "https://aws-mcp.us-east-1.api.aws/mcp",
-       "--metadata", "AWS_REGION=us-west-2"
+       "--metadata", "AWS_REGION=us-west-2",
+       "--profile", "work"
      ]
    }
  }
}
```

### パラメータも見てみる

統合された AWS API MCP は読み取り専用の MCP に設定できました。

これを利用することで、生成 AI が直接ターミナル上から CLI をコールするより安全に CLI を利用できたのですが AWS MCP Server も同様のことができるか確認しました。

下記ページに `--read-only` パラメータがあることを確認できたので、設定してみます。

https://github.com/aws/mcp-proxy-for-aws#configuration-parameters

ツールがなくなってしまいました。

![alt text](<CleanShot 2026-01-31 at 06.43.53@2x.png>)

`--read-only` パラメータの説明を見てみると、以下の記載がありました。

> Disable tools which may require write permissions (tools which DO NOT require write permissions are annotated with readOnlyHint=true)

また `--log-level` を設定し、MCP のログを見てみると、以下のようにすべてのツールに書き込み権限が必要な旨のメッセージがありました。

```text
Skipping tool aws___call_aws needing write permissions
Skipping tool aws___get_regional_availability needing write permissions
Skipping tool aws___list_regions needing write permissions
Skipping tool aws___read_documentation needing write permissions
Skipping tool aws___recommend needing write permissions
Skipping tool aws___retrieve_agent_sop needing write permissions
Skipping tool aws___search_documentation needing write permissions
Skipping tool aws___suggest_aws_commands needing write permissions
```

`aws___search_documentation` 等、明らかに読み取り専用のツールまで書き込み権限が必要とされている模様。

一応 Issue 起票しておきました。

https://github.com/aws/mcp-proxy-for-aws/issues/159

### ツール一覧

kiro-cli の `/tools` でツール一覧を見てみると以下のようなツールがありました。

確かに knowledge MCP が持っていたようなツールもありますね。

```text
aws-mcp (MCP)
- aws___call_aws                     not trusted
- aws___get_regional_availability    not trusted
- aws___list_regions                 not trusted
- aws___read_documentation           not trusted
- aws___recommend                    not trusted
- aws___retrieve_agent_sop           not trusted
- aws___search_documentation         not trusted
- aws___suggest_aws_commands         not trusted
```

下記のページでもツールの紹介がされていました。

https://docs.aws.amazon.com/aws-mcp/latest/userguide/understanding-mcp-server-tools.html

#### Agent SOP ツール

| ツール名 | 説明 |
| ------- | ---- |
| `aws___retrieve_agent_sop` | Agent SOP の検索、または特定の SOP の詳細情報を取得。利用可能なすべての SOP をリスト表示したり、特定の SOP の完全なワークフローを取得できる |

#### AWS Knowledge ツール

| ツール名 | 説明 |
| ------- | ---- |
| `aws___search_documentation` | API リファレンス、ベストプラクティス、サービスガイドを含むすべての AWS ドキュメントを検索 |
| `aws___read_documentation` | AWS ドキュメントページを取得し、AI アシスタントが利用しやすいように Markdown 形式に変換 |
| `aws___recommend` | AWS ドキュメントページの関連トピックやよく閲覧されるコンテンツに基づいてコンテンツを推薦 |
| `aws___list_regions` | すべての AWS リージョンのリストを取得（識別子と名前を含む） |
| `aws___get_regional_availability` | サービス、機能、SDK API、CloudFormation リソースの AWS リージョン別の利用可能性を確認 |

#### AWS API ツール

| ツール名 | 説明 |
| ------- | ---- |
| `aws___call_aws` | 適切な構文検証とエラー処理を備えた認証済み AWS API 呼び出しを実行。15,000 以上の AWS API の大部分をサポートし、自動的に認証情報を管理。**注意**: ファイルシステムアクセスやストリームレスポンスが必要な API は確実にサポートされていない |
| `aws___suggest_aws_commands` | 関連する AWS API の説明と構文ヘルプを取得。AI モデルのトレーニングデータにない新しくリリースされた API も含む |

## CloudTrail を確認してみる

次に CloudTrail で操作履歴を確認してみます。

CloudTrail はバージニア北部リージョンで確認する必要があり、イベントソースは `aws-mcp.amazonaws.com` となります。

確認してみると、接続時に `Initialize`、ツールを使った時に `CallReadWriteTool` のイベントを確認できました。

![alt text](<CleanShot 2026-02-02 at 04.28.32@2x.png>)

ただし、すべてのツール呼び出しでイベントが記録されるわけではないようです。

いくつか確認してみた感じ `aws___call_aws` のみ記録される模様です。

イベントレコードを見ると、どのツールが呼び出されたか程度がわかる内容ですね。

```json
    "requestParameters": {
        "jsonrpc": "2.0",
        "method": "tools/call",
        "id": 18,
        "params": {
            "name": "aws___call_aws",
            "_meta": "[HIDDEN_DUE_TO_SECURITY_REASONS]",
            "arguments": "[HIDDEN_DUE_TO_SECURITY_REASONS]"
        }
    },
```

このツール経由でどんな CLI コマンドが実行されたかまで記録してほしい気はします。

## まとめ

AWS MCP Server について、簡単に挙動の確認でした。

AWS の MCP のうち一番よく利用する knowledge MCP や、API MCP が統合されたので、私もこちらに乗り換えました。

が、以下のような点が少し物足りないので、今後のアップデートに期待です！

- `--read-only` パラメータが動作しない
- CloudTrail のイベント詳細が少し不足気味
- MCP 起動に `profile` の指定が必要なところが少し面倒
