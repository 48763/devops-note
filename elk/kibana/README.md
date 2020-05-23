## kibana
![](https://i.imgur.com/Vml1uLT.png)

將 Log 資料視覺化呈現。

## GUI 介紹

![](https://i.imgur.com/QHipVMj.png)

- 黑框
    - Discover：用以檢視各索引下的記錄內容及總記錄筆數
    - Visualize：將搜尋出的數據以長條圖、圓餅圖、表格等方式呈現
    - Dashboard：將以儲存的搜尋結果或已完成的圖表組合成一份快速報表
    - Timelion：時序性的監看 query
    - Dev Tools：提供一個在 kibana 直接呼叫 elasticsearch 的方式
    - Managment：設定 kibana 對應的 elasticsearch index patterns，管理已經儲存好的搜尋結果物件、視覺化結果物件，及進階資料過濾設定
- 紅框
    - Index：要搜索的 index pattern（Management 所設定的 index patterns create ）
- 咖啡框
    - Avaliable Fields：搜索 index 下所包含的屬性(也就是我們在 logstash 切出來的部分)
- 紫框
    - Timestamp：資料時間，可用於特定時間區間資料量觀察
- 藍框
    - source：顯示我們接收到的 log 資訊
- 綠框
    - 搜尋條件：預設 "*" 搜尋 index 下所有紀錄
