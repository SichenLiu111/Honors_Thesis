pragma circom 2.1.6;

include "node_modules/circomlib/circuits/comparators.circom";

// check each pixel
// build image from transcript and give constraints
template build_image(m, n) {
    signal input transcript[3]; // [x, y, length]
    signal output transcript_img[m][n];

    // assign remaining entries 0, line elements 1

    signal condition1[m];
    signal condition2[n];

    for (var i = 0; i < m; i++) {
        for (var j = 0; j < n; j++) {
            
        }
    }

}

// two images should have equal value for all enties
template equal_image() {
    signal input public_img[m][n];
    signal input transcript_img[m][n];

    component ie[m][n];

    for (var i = 0; i < m; i++) {
        for (var j = 0; j < n; j++) {
            ie[i][j] = IsEqual();
            ie.in[0] = pub_img[i][j];
            ie.in[1] = transcript_img[i][j];
        }
    }
}

// set constraints for draw line
template drawline(m, n) {
    signal input pub_img[m, n]; // public one
    signal input transcript[3]; // [x, y, length]

    // no output


    // build transcript image

    // constraint two images equal

}

component main { public [ pub_img ] }  = VarSubarray(3, 10);

// where to import transcript info?
// what if input does not satisfy the constraints?
// does same naming matters?
