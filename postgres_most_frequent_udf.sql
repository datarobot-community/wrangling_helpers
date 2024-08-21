CREATE FUNCTION _most_frequent(arr varchar[]) RETURNS varchar AS
$BODY$
DECLARE
    mode varchar;
    greatest_freq int := 0;
    numMapping jsonb = jsonb_build_object();
    temp_counter int;
    key_attr text;
BEGIN
    FOR i IN 1..array_upper(arr,1) LOOP
        key_attr :=arr[i]::text;
        temp_counter := (numMapping->>key_attr)::int;
        IF temp_counter is NULL THEN
          temp_counter:=0;
        END IF;
        numMapping :=  jsonb_set(numMapping, format('{%s}', key_attr)::text[], (temp_counter+1)::text::jsonb);
        IF (numMapping->>key_attr)::int >= greatest_freq THEN
            greatest_freq := (numMapping->>key_attr)::int;
            mode := arr[i];
        END IF;

    END LOOP;
    RETURN mode;
END;
$BODY$
LANGUAGE plpgsql;

CREATE AGGREGATE rolling_most_frequent(varchar) (
    SFUNC = array_append,
    STYPE = varchar[],
    FINALFUNC =_most_frequent,
    INITCOND = '{}'
    );
