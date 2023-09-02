
# inaba-infra
# 構成
```
├─env(環境毎の差分吸収)
│  ├─dev
│  └─prod
├─modules(各サービス毎に使う汎用モジュール)
│  └─*
└─services(サービス毎の差分吸収)
    └─*
```

<br>

# 前提条件
* terraform
* aws cli
* pre-commit
* tflint
* terraform-docs

<br>

# 準備
pre-commitの適応
```
pre-commit install
```

tflint用の設定ファイルをホームディレクトリに作成  
path: ~/.tflint.hcl
```
plugin "aws" {
  enabled = true
  version = "0.26.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_required_version" {
  enabled = false
}

rule "terraform_required_providers" {
  enabled = false
}
```

tflintにプラグインを適応
```
tflint --init
```

<br>


# インフラ構築
対象環境のディレクトリに移動
```bash
cd ./env/dev
```

terraformコマンド実行

```bash
terraform init
terrafrom apply
```

しばらく待つと、"本当にインフラ作っちゃっていいの？" って聞かれるので`yes`と入力してEnter!
> Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

<br>

# インフラ破壊
 `init, apply`したディレクトリに移動してdestroyコマンドを発行します

 ```bash
 terraform destroy
 ```

しばらく待つと、"全部消すけどええんか？"って聞かれるので`yes`を入力してEnter!
> Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.
