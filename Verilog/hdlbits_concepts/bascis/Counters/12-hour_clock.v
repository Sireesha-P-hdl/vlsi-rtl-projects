/*
Create a set of counters suitable for use as a 12-hour clock (with am/pm indicator).

Inputs:
- clk   : Fast-running clock
- ena   : Pulse that increments the clock once per second
- reset : Synchronous active-high reset (resets time to 12:00:00 AM)

Outputs:
- pm : 0 = AM, 1 = PM
- hh : Hours in BCD (01–12)
- mm : Minutes in BCD (00–59)
- ss : Seconds in BCD (00–59)

Requirements:
- Reset has higher priority than enable
- Clock rolls over correctly from 11:59:59 AM to 12:00:00 PM
- PM toggles only at 11 → 12 transition
*/
module top_module (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] ss_l, ss_h;
    reg [3:0] mm_l, mm_h;
    reg [3:0] hh_l, hh_h;

    // Seconds (ones)
    always @(posedge clk) begin
        if (reset)
            ss_l <= 4'd0;
        else if (ena) begin
            if (ss_l == 4'd9)
                ss_l <= 4'd0;
            else
                ss_l <= ss_l + 1'b1;
        end
    end

    // Seconds (tens)
    always @(posedge clk) begin
        if (reset)
            ss_h <= 4'd0;
        else if (ena && ss_l == 4'd9) begin
            if (ss_h == 4'd5)
                ss_h <= 4'd0;
            else
                ss_h <= ss_h + 1'b1;
        end
    end

    // Minutes (ones)
    always @(posedge clk) begin
        if (reset)
            mm_l <= 4'd0;
        else if (ena && ss_l == 4'd9 && ss_h == 4'd5) begin
            if (mm_l == 4'd9)
                mm_l <= 4'd0;
            else
                mm_l <= mm_l + 1'b1;
        end
    end

    // Minutes (tens)
    always @(posedge clk) begin
        if (reset)
            mm_h <= 4'd0;
        else if (ena && ss_l==4'd9 && ss_h==4'd5 && mm_l==4'd9) begin
            if (mm_h == 4'd5)
                mm_h <= 4'd0;
            else
                mm_h <= mm_h + 1'b1;
        end
    end

    // Hours (ones)
    always @(posedge clk) begin
        if (reset)
            hh_l <= 4'd2;              // 12 AM
        else if (ena && ss_l==4'd9 && ss_h==4'd5 && mm_l==4'd9 && mm_h==4'd5) begin
            if (hh_l == 4'd9)
                hh_l <= 4'd0;
            else if (hh_h == 4'd1 && hh_l == 4'd2)
                hh_l <= 4'd1;          // 12 → 1
            else
                hh_l <= hh_l + 1'b1;
        end
    end

    // Hours (tens) + PM control
    always @(posedge clk) begin
        if (reset) begin
            hh_h <= 4'd1;
            pm   <= 1'b0;              // AM
        end
        else if (ena && ss_l==4'd9 && ss_h==4'd5 && mm_l==4'd9 && mm_h==4'd5) begin
            if (hh_h == 4'd0 && hh_l == 4'd9)
                hh_h <= 4'd1;          // 09 → 10
            else if (hh_h == 4'd1 && hh_l == 4'd2)
                hh_h <= 4'd0;          // 12 → 01

            if (hh_h == 4'd1 && hh_l == 4'd1)
                pm <= ~pm;             // Toggle AM/PM at 11 → 12
        end
    end

    assign ss = {ss_h, ss_l};
    assign mm = {mm_h, mm_l};
    assign hh = {hh_h, hh_l};

endmodule
