module mux16_1_hierarchy_tb;

    reg  [15:0] I;
    reg  [3:0]  sel;

    wire y_ref;       // mux_16_1            - direct case-based reference
    wire y_v1;        // mux16_1using2_1      - 8x2:1 -> 2x4:1 -> 1x2:1
    wire y_v2;        // mux_16_1using4_1     - 4x4:1 -> 1x4:1
    wire y_v3;        // mux_16_1using8_1     - 2x8:1 -> 1x2:1

    integer i, j, errors;

    mux_16_1          u_ref (.I(I), .sel(sel), .y(y_ref));
    mux16_1using2_1   u_v1  (.I(I), .sel(sel), .y(y_v1));
    mux_16_1using4_1  u_v2  (.I(I), .sel(sel), .y(y_v2));
    mux_16_1using8_1  u_v3  (.I(I), .sel(sel), .y(y_v3));

    task check_all;
        begin
            #5; // let combinational logic settle
            if (y_ref !== I[sel] || y_v1 !== y_ref || y_v2 !== y_ref || y_v3 !== y_ref) begin
                $display("FAIL: I=%h sel=%0d  ref=%b v1(2:1)=%b v2(4:1)=%b v3(8:1)=%b  expected=%b",
                          I, sel, y_ref, y_v1, y_v2, y_v3, I[sel]);
                errors = errors + 1;
            end else begin
                $display("PASS: sel=%0d  y=%b (all 4 versions agree, matches I[%0d])",
                          sel, y_ref, sel);
            end
        end
    endtask

    initial begin
        errors = 0;

        $display("---- Exhaustive sweep: fixed data pattern, all 16 sel values ----");
        I = 16'b1011_0100_1110_0010; // arbitrary fixed pattern
        for (i = 0; i < 16; i = i + 1) begin
            sel = i[3:0];
            check_all;
        end

        $display("\n---- Randomized sweep: random data + random sel, 10 trials ----");
        for (j = 0; j < 10; j = j + 1) begin
            I   = $random;
            sel = $random;
            check_all;
        end

        if (errors == 0)
            $display("\nALL TESTS PASSED - all four 16:1 mux implementations agree");
        else
            $display("\n%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule
