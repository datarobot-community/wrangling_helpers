create function ROLLING_MOST_FREQUENT(N VARCHAR, V FLOAT)
    returns TABLE (MOST_FREQUENT VARCHAR)
    language JAVASCRIPT
as
$$
{
    processRow: function f(row, rowWriter, context){
        var result = null;
        this.pointarr.push(row.N);
        if (this.pointarr.length == row.V){
            // Calculate mode.
            result = this.most_frequent(this.pointarr);
            this.pointarr.shift(); // Drop First element
        }
        else {
            result = null; // null for elements before window end
        }

        rowWriter.writeRow({MOST_FREQUENT: result});
        
    },        
        initialize: function(argumentInfo, context) {
        this.pointarr = [];
        this.most_frequent = function(arr){
          let numMapping = {};
          let mode
          let greatestFreq = 0;
          for(var i = 0; i < arr.length; i++){
              if(numMapping[arr[i]] === undefined){
                  numMapping[arr[i]] = 0;
              }
              numMapping[arr[i]] += 1;
              if (numMapping[arr[i]] >= greatestFreq){
                greatestFreq = numMapping[arr[i]]
                mode = arr[i]
              }
          }
          return mode         
      }
    }
}
$$;

