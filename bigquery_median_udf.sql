create function functional_test.rolling_median(arr ANY TYPE) as
    (
        (
  SELECT
    IF(
      MOD(ARRAY_LENGTH(arr), 2) = 0,
      (arr[OFFSET(DIV(ARRAY_LENGTH(arr), 2) - 1)] + arr[OFFSET(DIV(ARRAY_LENGTH(arr), 2))]) / 2,
      arr[OFFSET(DIV(ARRAY_LENGTH(arr), 2))]
    )
  FROM (SELECT ARRAY_AGG(x ORDER BY x) AS arr FROM UNNEST(arr) AS x   WHERE x IS NOT NULL)
));

