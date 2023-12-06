pragma circom 2.1.6;

// include "circomlib/comparators.circom";
include "node_modules/circomlib/circuits/comparators.circom";
// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";

// function isReached(i, posiX) {

//     component ie = IsEqual();

//     ie.in[0] <== i;
//     ie.in[1] <== posiX;
//     return ie.out;

// }

// function isGreaterEqualTo(j, posiY) {

//     component gt = GreaterEqThan(8);

//     gt.in[0] <== j;
//     gt.in[1] <== posiY;
//     return gt.out;

// }

template generateGraph (length, width) {
    
    signal input posiX;
    signal input posiY;
    signal input size;

    // signal condition1;
    // signal condition2;

    signal output out[length][width];

    // array of components
    // component ie = IsEqual();
    // component gt = GreaterEqThan(8);

    // loop to convert the transcript to grid with size of length * width
    for(var i = 0; i < length; i++) {

        for (var j = 0; j < width; j++) {

            // ie.in[0] <== i;
            // ie.in[1] <== posiX;
            // var xIsReached = ie.out;

            // gt.in[0] <== j;
            // gt.in[1] <== posiY;
            // var yGtEqThan = gt.out;

            // var xIsReached = isReached(i, posiX);
            // var yGtEqThan = isGreaterEqualTo(j, posiY);

            var xIsReached = i == posiX ? 1 : 0;
            var yGtEqThan = j == posiY ? 1 : 0;

            var condition1 = xIsReached == 1 ? 1 : 0;
            var condition2 = yGtEqThan == 1 && j < (posiY + size) ? 1 : 0;

            // if (xIsReached == 1) {

            //     gt.in[0] <== j;
            //     gt.in[1] <== posiY;

            //     var yGtEqThan = gt.out;

            //     condition2 = 1;

            //     if (yGtEqThan == 1 && j < (posiY + size)) {

            //         condition1 = 1;

            //     } else {

            //         condition1 = 0;

            //     }

            // } else {

            //     condition2 = 0;

            // }

            // ===
            out[i][j] <-- condition1 * condition2;

        }

    }

}

template Example (length, width) {

    // is revealing everything including the transcript violates the original design?
    // should set them as signal instead?

    // the canvas with the line
    signal input canvas[length][width];

    // the position of the graph (transcript)
    signal input posiX;
    signal input posiY;

    // the shape of the graph
    // a line
    signal input size;

    // if the transcript matched with the canvas, return 1, else 0;
    signal output ifMatched;


    // get the canvas to verify with transcript
    component drawGraph = generateGraph(length, width);
    drawGraph.posiX <== posiX;
    drawGraph.posiY <== posiY;
    drawGraph.size <== size;

    signal transcript_canvas[length][width] <== drawGraph.out;
    
    // create a loop to verify
    for(var i = 0; i < length; i++) {

        for (var j = 0; j < width; j++) {

            assert(transcript_canvas[i][j] == canvas[i][j]);

        }

    }

    ifMatched <== 1;
    
}

component main = Example(10, 20);

/* INPUT = {
    "canvas": [
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  ],
  "posiX": 2,
  "posiY": 5,
  "size": 3
} */
