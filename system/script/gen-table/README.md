# gen-table

指令的使用方式: 

```
$ gen-table prod-info.list
| App Name | CD Status | System | Type | Project | Build | Deploy |
| :- | :-: | -: | -: | -: | -: | -: |
| [APP_NAME](https://yayuyo.yt) | [![Build Status](../../../img/system/script/gen-table.png)](https://yayuyo.yt) | `Linux` | `Container` | [PROJECT_NAME](https://yayuyo.yt) | [CI_BUILD_NAME](https://yayuyo.yt) | [CD_DEPLOY_NAME](https://yayuyo.yt) |
```

在 `.md` 中的呈現: 

| App Name | CD Status | System | Type | Project | Build | Deploy |
| :- | :-: | -: | -: | -: | -: | -: |
| [APP_NAME](https://yayuyo.yt) | [![Build Status](../../../img/system/script/gen-table.png)](https://yayuyo.yt) | `Linux` | `Container` | [PROJECT_NAME](https://yayuyo.yt) | [CI_BUILD_NAME](https://yayuyo.yt) | [CD_DEPLOY_NAME](https://yayuyo.yt) |

## 資訊清單

設置欄位名稱和文字對齊:

```
L Row Name
M CD Status
R System
<Space_line>
```

- `L`: 置右對齊
- `M`: 置中對齊
- `R`: 置左對齊
- `Row Name`: 後半都是名稱範圍
- `<Space_line>`: 空白行為欄位邊界，結束欄位的設定


設置資訊:

```
L https://yayuyo.yt APP_NAME
S [![Build Status](../../../img/system/script/gen-table.png)](https://yayuyo.yt) 
S `Linux` 
<Space_line>
---
<Space_line>
```

- `L`: 後面資訊組成鏈結，第一個為鏈結，第二個為顯示名稱（任意字元和長度），第一行顯示為 - [APP_NAME](https://yayuyo.yt)
- `S`: 純字串，接受任意字元和長度。第二行顯示為 - [![Build Status](../../../img/system/script/gen-table.png)](https://yayuyo.yt)，第三行顯示為 - `Linux` 
- `<Space_line>`: 空白行會忽略，但文件最後必須有空白行。
- `---`: 該列的設定結束
