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
            updated_canvas[i][j] <== cur_canvas[i][j] + isZeroOut[i][j] * cur_transcript[i][j];
        }
    }
}

template assign_canvas(m, n) {
    signal input cur_transcript[m][n];
    signal input cur_canvas[m][n];
    
    signal output output_canvas[m][n];

    component com = update_canvas(m, n);
    com.cur_transcript <== cur_transcript;
    com.cur_canvas <== cur_canvas;
    output_canvas <== com.updated_canvas;
}

template iter_transcripte(m, n, s) {
    signal input tcs[s][m][n];
    signal input current_canvas[m][n];

    signal output updates[s+1][m][n];

    updates[0] <== current_canvas;

    component coms[s];

    for (var i = 0; i < s; i++) {
        coms[i] = assign_canvas(m, n);
        coms[i].cur_transcript <== tcs[i];
        coms[i].cur_canvas <== updates[i];
        updates[i+1] <== coms[i].output_canvas;
    }
}

template get_tcs_image(m, n, s) {
    signal input tcs[s][m][n];
    signal input current_canvas[m][n];
    
    signal output tcs_image[m][n];

    component com = iter_transcripte(m, n, s);
    com.tcs <== tcs;
    com.current_canvas <== current_canvas;
    tcs_image <== com.updates[s];
}

template verify(m, n, s) {
    signal input tcs[s][m][n];
    signal input current_canvas[m][n];
    signal input public_image[m][n];

    // signal output isSameImage;

    component com1 = get_tcs_image(m, n, s);
    com1.tcs <== tcs;
    com1.current_canvas <== current_canvas;

    component com2 = equal_grid(m, n);
    com2.public_img <== public_image;
    com2.transcript_img <== com1.tcs_image;

}

// template iterate_transcripts(m, n, s) {
//     signal input canvas_zeros[m][n];
//     signal input cur_transcripts[s][m][n];
//     signal output output_canvas[m][n];

//     signal records[s+1][m][n];
//     component coms[s];

//     records[0] <== canvas_zeros;

//     for (var i = 0; i < s; i++) {
//         coms[i] = update_canvas(m, n);
//         coms.cur_transcript <== cur_transcripts[i];
//         coms.cur_canvas <== records[i];
//         coms.updated_canvas ==> records[i+1];
//     }

//     output_canvas <== records[s];
// }

// component main {public [cur_canvas] } = update_canvas(2, 2);
component main {public [public_image] } = verify(2, 2, 2);
// component main {public [cur_transcripts] } = iterate_transcripts(2, 2, 2);

/* INPUT = {
    "tcs": 
    [[
        [0, 0],
        [1, 0]
    ],
    [
        [0, 1],
        [0, 0]
    ]],
    "current_canvas": 
    [
        [0, 0],
        [0, 0]
    ],
    "public_image":
    [
        [0, 1],
        [1, 0]
    ]
  } */