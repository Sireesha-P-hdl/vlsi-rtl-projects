`timescale 1ns / 1ps
module seq_dect_tb();


    reg clk = 0;
    reg rst, w;
    wire y;

    seq_dect DUT (.clk(clk), .rst(rst), .w(w), .y(y));

    always #5 clk = ~clk;

    // set the bit, let y settle, print, then advance one clock
    task send(input b);
        begin
            w = b;
            #1;
            $display("w=%b  y=%b", b, y);
            @(negedge clk);
        end
    endtask

    initial begin
        rst = 1; w = 0;
        @(negedge clk);
        rst = 0;

        $display("stream 1011011 - expect y=1 twice");

        send(1);
        send(0);
        send(1);
        send(1);   // y = 1 here
        send(0);
        send(1);
        send(1);   // y = 1 here again

        $finish;
    end

endmodule
