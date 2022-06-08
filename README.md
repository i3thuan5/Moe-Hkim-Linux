# MOE-Hkim-Linux

`ngienbun/`原本檔案係[臺灣客家語拼音輸入法](https://language.moe.gov.tw/result.aspx?classify_sn=42&subclassify_sn=447)Linux个。

## 詞表
```
sudo apt install scim-modules-table
mkdir -p text
find ngienbun/ -type f -name '*bin' -exec scim-make-table {} -o text/{}.txt \;
```
