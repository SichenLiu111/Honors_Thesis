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

template update_canvas(m, n) {
    signal input cur_transcript[m][n];
    signal input cur_canvas[m][n];
    signal output updated_canvas[m][n];

    component isZeroCom[m][n];
    signal isZeroOut[m][n];

    for (var i = 0; i < m; i++) {
        for (var j = 0; j < n; j++) {
            // non zero
            isZeroCom[i][j] = isEqual();
            isZeroCom[i][j].in0 <== 0;
            isZeroCom[i][j].in1 <== cur_canvas[i][j];
            isZeroOut[i][j] <== isZeroCom[i][j].out;
            // if is zero (equal 0), return 1, then update with cur_canvas[i][j] (0) + 1 * cur_transcript[i][j], 
            // else update with cur_canvas[i][i] + 0 * cur_transcript[i][j] (0)
            // need to fix for colors: another var?
            updated_canvas[i][j] <== cur_canvas[i][j] + isZeroOut[i][j] * cur_transcript[i][j];
        }
    }
}

template read_transcript(m, n, size) {
    signal input transcripts[size][m][n];
    signal input public_canvas[m][n];

    signal current_canvas[size + 1][m][n];

    // assian 0s to current_canvas[0]?
    
    component multiple_updates[size];

    for (var s = 0; s < size; s++) {
        multiple_updates[s] = update_canvas(m, n);
        multiple_updates[s].cur_transcript <== transcripts[s];
        multiple_updates[s].cur_canvas <== current_canvas[s];
        current_canvas[s + 1] <== multiple_updates.updated_canvas;
    }

    // compare

}

