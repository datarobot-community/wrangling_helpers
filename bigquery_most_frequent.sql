create function schema_name.rolling_most_frequent(arr ARRAY<STRING>) as
    (
        (
  SELECT y_arr
  FROM  UNNEST(ARRAY_REVERSE(arr)) as y_arr
  WHERE y_arr IS NOT NULL
  GROUP BY y_arr
  ORDER BY COUNT(1) DESC
  LIMIT 1
));

