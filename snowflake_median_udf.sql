create function ROLLING_MEDIAN(N FLOAT, V FLOAT)
    returns TABLE (MEDIAN FLOAT)
    language JAVASCRIPT
as
$$
{
    processRow: function f(row, rowWriter, context){
        var result = null;
        this.pointarr.push(row.N);
        if (this.pointarr.length == row.V){
            // Calculate Median.
            result = this.median(this.pointarr);
            this.pointarr.shift(); // Drop First element
        }
        else {
            result = null; // null for elements before window end
        }

        rowWriter.writeRow({MEDIAN: result});
        
    }        
    , initialize: function(argumentInfo, context) {
        this.pointarr = [];
        this.median = function(values){
            const sortedValues = values
                .filter((element) => !isNaN(element))
                .sort((a, b) => a - b);

            if (!sortedValues.length) {
                return null;
            }

            const half = Math.floor(sortedValues.length / 2);

            if (sortedValues.length % 2) {
                return sortedValues[half];
            }

            return (sortedValues[half - 1] + sortedValues[half]) / 2;
        }
    }
}
$$;

