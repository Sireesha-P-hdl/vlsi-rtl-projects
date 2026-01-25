`timescale 1ns/1ps

module tb_alarm_clock_23_59;

    reg clock;
    reg reset;
    reg alarm_button;
    reg time_button;
    reg [3:0] key;
    reg key_valid;
    reg fastwatch;

    wire sound_alarm;

    // Clock: 100 MHz
    always #5 clock = ~clock;

    // DUT
    alarm_clock_top DUT (
        .clock(clock),
        .reset(reset),
        .alarm_button(alarm_button),
        .time_button(time_button),
        .key(key),
        .key_valid(key_valid),
        .fastwatch(fastwatch),
        .sound_alarm(sound_alarm)
    );

    initial begin
        
        $dumpfile("alarm_clock_23_59.vcd");
        $dumpvars(0, tb_alarm_clock_23_59);

        // -------------------------
        // INITIALIZATION
        // -------------------------
        clock = 0;
        reset = 1;
        alarm_button = 0;
        time_button  = 0;
        key = 0;
        key_valid = 0;
        fastwatch = 1;

        #20 reset = 0;

        // -------------------------
        // SET CURRENT TIME = 23:59
        // -------------------------
        #20;
        time_button = 1;
        #10 time_button = 0;

        key = 4'd9;
        key_valid = 1;
        #10 key_valid = 0;

        // -------------------------
        // SET ALARM TIME = 23:59
        // -------------------------
        #20;
        alarm_button = 1;
        #10 alarm_button = 0;

        key = 4'd9;
        key_valid = 1;
        #10 key_valid = 0;

        // -------------------------
        // WAIT & CHECK ALARM
        // -------------------------
        #50;

        if (sound_alarm)
            $display(" ALARM TRIGGERED SUCCESSFULLY AT 23:59");
        else
            $display(" ALARM DID NOT TRIGGER");

        #20 $finish;
    end

endmodule

