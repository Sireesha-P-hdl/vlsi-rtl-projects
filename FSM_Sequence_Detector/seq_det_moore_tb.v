`timescale 1ns / 1ps
module seq_det_tb();

    reg clk = 0;
    reg reset, w;
    wire y;

    seq_dect DUT (.clk(clk), .reset(reset), .w(w), .y(y));

    always #5 clk = ~clk;

    task send(input b);
        begin
            w = b;
            @(negedge clk);
            $display("w=%b  y=%b", b, y);
        end
    endtask

    initial begin
        reset = 1; w = 0;
        @(negedge clk);
        reset = 0;

        $display("stream 1011011 - expect y=1 twice");

        send(1);
        send(0);
        send(1);
        send(1);   // y = 1
        send(0);
        send(1);
        send(1);   // y = 1

        $finish;
    end

endmodule
