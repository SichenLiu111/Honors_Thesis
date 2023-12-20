pragma circom 2.1.6;



template isZero() {
    signal input in;
    signal output out;

    signal inv;

    inv <-- in!=0 ? 1/in : 0;

    out <== -in*inv +1;
    in*out === 0;
}

template isEqual() {
    signal input in0;
    signal input in1;
    signal output out;

    component isz = isZero();

    in1 - in0 ==> isz.in;

    isz.out ==> out;
}

// template isEqual() {
    
//     signal input in0;
//     signal input in1;

//     (in0 - in1) === 0;
// }


template equal_grid(m, n) {

    signal input public_img[m][n];
    signal input transcript_img[m][n];

    component is_equal[m][n];

    for (var i = 0; i < m; i++) {
        for (var j = 0; j < n; j++) {
            is_equal[i][j] = isEqual();
            is_equal[i][j].in0 <== public_img[i][j];
            is_equal[i][j].in1 <== transcript_img[i][j];
        }
    }

}


component main {public[public_img]} = equal_grid(3, 3);




