
module mux_hierarchy_tb;

    // ---------- Signals for 4:1 comparison (direct vs hierarchical) ----------
    reg  [3:0] I4;
    reg  [1:0] sel2;
    wire       y_direct4, y_hier4;

    // ---------- Signals for 8:1 hierarchical ----------
    reg  [7:0] d8;
    reg  [2:0] sel3;
    wire       y_hier8;

    integer i, errors;

    // DUTs
    mux4_1            u_direct4 (.I(I4), .sel(sel2), .y(y_direct4));
    mux4_1using2_1    u_hier4   (.I(I4), .sel(sel2), .y(y_hier4));
    mux8_1using4_1and2_1 u_hier8 (.d(d8), .sel(sel3), .y(y_hier8));

    initial begin
        errors = 0;

        $display("---- 4:1 MUX check: direct case-based vs hierarchical (2:1 based) ----");
        I4 = 4'b1011; // I0=1,I1=1,I2=0,I3=1 (arbitrary fixed pattern)
        for (i = 0; i < 4; i = i + 1) begin
            sel2 = i[1:0];
            #5;
            if (y_direct4 !== y_hier4 || y_direct4 !== I4[sel2]) begin
                $display("FAIL: sel=%0d direct=%b hier=%b expected=%b",
                          sel2, y_direct4, y_hier4, I4[sel2]);
                errors = errors + 1;
            end else begin
                $display("PASS: sel=%0d y=%b (matches I[%0d]=%b)",
                          sel2, y_direct4, sel2, I4[sel2]);
            end
        end

        $display("\n---- 8:1 MUX check: hierarchical (4:1 + 2:1 based) ----");
        d8 = 8'b10110100; // arbitrary fixed pattern, d8[7:0]
        for (i = 0; i < 8; i = i + 1) begin
            sel3 = i[2:0];
            #5;
            if (y_hier8 !== d8[sel3]) begin
                $display("FAIL: sel=%0d y=%b expected=%b", sel3, y_hier8, d8[sel3]);
                errors = errors + 1;
            end else begin
                $display("PASS: sel=%0d y=%b (matches d[%0d]=%b)",
                          sel3, y_hier8, sel3, d8[sel3]);
            end
        end

        $display("\n---- Randomized check on 8:1 MUX (5 random data patterns) ----");
        for (i = 0; i < 5; i = i + 1) begin
            d8 = $random;
            sel3 = $random;
            #5;
            if (y_hier8 !== d8[sel3]) begin
                $display("FAIL: d=%b sel=%0d y=%b expected=%b", d8, sel3, y_hier8, d8[sel3]);
                errors = errors + 1;
            end else begin
                $display("PASS: d=%b sel=%0d y=%b", d8, sel3, y_hier8);
            end
        end

        if (errors == 0)
            $display("\nALL TESTS PASSED");
        else
            $display("\n%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule
