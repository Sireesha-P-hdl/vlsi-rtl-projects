`timescale 1ns / 1ps
/***************************************************
 FULL ALARM CLOCK RTL – MERGED
***************************************************/


/***************************************************
 Alarm Controller FSM
***************************************************/
module alarm_controller_FSM(
    reset,
    clock,
    alarm_button,
    time_button,
    key,
    key_valid,
    show_new_time,
    show_alarm,
    load_new_alarm,
    load_new_time
);

input reset, clock;
input alarm_button, time_button;
input [3:0] key;
input key_valid;

output show_new_time;
output show_alarm;
output load_new_alarm;
output load_new_time;

reg [2:0] state, pre_state;

parameter NORMAL     = 3'b000,
          SET_TIME   = 3'b001,
          SET_ALARM  = 3'b010,
          KEY_STORED = 3'b011;

always @(posedge clock or posedge reset) begin
    if (reset)
        state <= NORMAL;
    else
        state <= pre_state;
end

always @(*) begin
    pre_state = state;
    case (state)
        NORMAL: begin
            if (time_button)
                pre_state = SET_TIME;
            else if (alarm_button)
                pre_state = SET_ALARM;
        end

        SET_TIME: begin
            if (key_valid)
                pre_state = KEY_STORED;
        end

        SET_ALARM: begin
            if (key_valid)
                pre_state = KEY_STORED;
        end

        KEY_STORED:
            pre_state = NORMAL;
    endcase
end

assign show_new_time  = (state == SET_TIME);
assign show_alarm     = (state == SET_ALARM);
assign load_new_time  = (pre_state == KEY_STORED && state == SET_TIME);
assign load_new_alarm = (pre_state == KEY_STORED && state == SET_ALARM);

endmodule


/***************************************************
 Counter
***************************************************/
module counter (
    clk,
    reset,
    enable,
    max,
    count,
    time_out
);

input clk, reset, enable;
input [5:0] max;
output reg [5:0] count;
output time_out;

assign time_out = (count == max);

always @(posedge clk or posedge reset) begin
    if (reset)
        count <= 6'd0;
    else if (enable) begin
        if (count == max)
            count <= 6'd0;
        else
            count <= count + 1'b1;
    end
end

endmodule


/***************************************************
 Alarm Register
***************************************************/
module alarm_reg (
    new_alarm_ms_min,
    new_alarm_ls_min,
    reset,
    load_alarm,
    clock,
    alarm_time_ms_min,
    alarm_time_ls_min
);

input [5:0] new_alarm_ms_min;
input [5:0] new_alarm_ls_min;
input reset, load_alarm, clock;

output reg [5:0] alarm_time_ms_min;
output reg [5:0] alarm_time_ls_min;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        alarm_time_ms_min <= 6'd0;
        alarm_time_ls_min <= 6'd0;
    end else if (load_alarm) begin
        alarm_time_ms_min <= new_alarm_ms_min;
        alarm_time_ls_min <= new_alarm_ls_min;
    end
end

endmodule


/***************************************************
 Key Register
***************************************************/
module keyreg(
    reset,
    clock,
    key,
    key_valid,
    key_buffer_ms_min,
    key_buffer_ls_min
);

input reset, clock;
input [3:0] key;
input key_valid;

output reg [5:0] key_buffer_ms_min;
output reg [5:0] key_buffer_ls_min;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        key_buffer_ms_min <= 6'd0;
        key_buffer_ls_min <= 6'd0;
    end else if (key_valid) begin
        key_buffer_ms_min <= key_buffer_ls_min;
        key_buffer_ls_min <= key;
    end
end

endmodule


/***************************************************
 Timing Generator
***************************************************/
module timegen(
    clock,
    reset,
    reset_count,
    fastwatch,
    one_second,
    one_minute
);

input clock, reset, reset_count, fastwatch;
output one_second, one_minute;

reg [25:0] count;
reg one_second_reg, one_minute_reg;

always @(posedge clock or posedge reset) begin
    if (reset)
        count <= 26'd0;
    else if (reset_count)
        count <= 26'd0;
    else
        count <= count + 1'b1;
end

always @(*) begin
    if (fastwatch) begin
        one_second_reg = 1'b1;
        one_minute_reg = count[3];
    end else begin
        one_second_reg = (count == 26'd50_000_000);
        one_minute_reg = (count == 26'd3_000_000_000);
    end
end

assign one_second = one_second_reg;
assign one_minute = one_minute_reg;

endmodule


/***************************************************
 Alarm Match Comparator (NEW)
***************************************************/
module alarm_match (
    input  [4:0] cur_hour,
    input  [5:0] cur_min,
    input  [4:0] alarm_hour,
    input  [5:0] alarm_min,
    output       sound_alarm
);

    assign sound_alarm =
        (cur_hour == alarm_hour) &&
        (cur_min  == alarm_min);

endmodule


/***************************************************
 TOP MODULE – MAIN RTL
***************************************************/
module alarm_clock_top (
    input clock,
    input reset,
    input alarm_button,
    input time_button,
    input [3:0] key,
    input key_valid,
    input fastwatch,
    output sound_alarm
);

    // Current time (demo / TB driven)
    reg [4:0] cur_hour;
    reg [5:0] cur_min;

    // Alarm time
    wire [5:0] alarm_ms_min;
    wire [5:0] alarm_ls_min;

    wire show_new_time, show_alarm;
    wire load_new_alarm, load_new_time;

    // FSM
    alarm_controller_FSM FSM (
        .reset(reset),
        .clock(clock),
        .alarm_button(alarm_button),
        .time_button(time_button),
        .key(key),
        .key_valid(key_valid),
        .show_new_time(show_new_time),
        .show_alarm(show_alarm),
        .load_new_alarm(load_new_alarm),
        .load_new_time(load_new_time)
    );

    // Alarm register
    alarm_reg ALARM (
        .new_alarm_ms_min(6'd23),   // TB can override
        .new_alarm_ls_min(6'd59),
        .reset(reset),
        .load_alarm(load_new_alarm),
        .clock(clock),
        .alarm_time_ms_min(alarm_ms_min),
        .alarm_time_ls_min(alarm_ls_min)
    );

    // Current time register (for simulation)
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            cur_hour <= 5'd0;
            cur_min  <= 6'd0;
        end else if (load_new_time) begin
            cur_hour <= 5'd23;
            cur_min  <= 6'd59;
        end
    end

    // Alarm trigger
    alarm_match MATCH (
        .cur_hour(cur_hour),
        .cur_min(cur_min),
        .alarm_hour(alarm_ms_min[4:0]),
        .alarm_min(alarm_ls_min),
        .sound_alarm(sound_alarm)
    );

endmodule
