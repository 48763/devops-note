# 03

```SQL
SELECT c.class
FROM score s
JOIN class c ON c.name = s.name
ORDER BY s.score DESC
LIMIT 1 OFFSET 1;
```