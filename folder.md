# フォルダ構成

- フォルダ構成は以下の通り

```
.
└── envs
    ├── backend.tf            tfstateファイル管理定義ファイル
    ├── compartments.tf       デプロイ用コンパートメント定義ファイル
    ├── compute.tf            OCI compute(Oracle Linux)定義ファイル
    ├── data.tf               外部データソース定義ファイル
    ├── locals.tf             ローカル変数定義ファイル
    ├── logging.tf             ログ関連定義ファイル
    ├── outputs.tf            リソース戻り値定義ファイル
    ├── providers.tf          プロバイダー定義ファイル
    ├── tags.tf               デフォルトタグ定義ファイル
    ├── userdata
    │   └── oracle_init.sh    Linux用userdataスクリプト
    ├── variables.tf          変数定義ファイル
    ├── vcn.tf                VCN定義ファイル
    └── versions.tf           Terraformバージョン定義ファイル
```
