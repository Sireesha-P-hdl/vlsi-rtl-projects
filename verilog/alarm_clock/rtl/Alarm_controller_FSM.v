module alarm_controller (
    input        clock,
    input        reset,
    input        alarm_button,
    input        time_button,
    input  [3:0] key,
    input        time_out,

    output       show_new_time,
    output       show_a,
    output       load_new_a,
    output       load_new_c,
    output       reset_count,
    output       shift
);


// State encoding

parameter SHOW_TIME        = 3'b000;
parameter SHOW_ALARM       = 3'b001;
parameter SET_ALARM_TIME   = 3'b010;
parameter SET_CURRENT_TIME = 3'b011;
parameter KEY_ENTRY       = 3'b100;
parameter KEY_STORED      = 3'b101;
parameter KEY_WAITED      = 3'b110;

parameter NOKEY = 4'b1111;


// State registers

reg [2:0] pre_state;
reg [2:0] next_state;


// State register update

always @(posedge clock or posedge reset)
begin
    if (reset)
        pre_state <= SHOW_TIME;
    else
        pre_state <= next_state;
end


// Next state logic

always @(*)
begin
    case (pre_state)

       
        // SHOW_TIME state
        
        SHOW_TIME : begin
            // If alarm button pressed → SHOW_ALARM
            if (alarm_button)
                next_state = SHOW_ALARM;

            // If key pressed → KEY_STORED
            else if (key != NOKEY)
                next_state = KEY_STORED;

            // Else remain in SHOW_TIME
            else
                next_state = SHOW_TIME;
        end

        
        // SHOW_ALARM state
        
        SHOW_ALARM : begin
            // If alarm button released → SHOW_TIME
            if (!alarm_button)
                next_state = SHOW_TIME;
            else
                next_state = SHOW_ALARM;
        end

       
        // KEY_STORED state
       
        KEY_STORED : begin
            next_state = KEY_WAITED;
        end

        
        // KEY_WAITED state
        
        KEY_WAITED : begin
            // If key released → KEY_ENTRY
            if (key == NOKEY)
                next_state = KEY_ENTRY;

            // If timeout occurs → SHOW_TIME
            else if (time_out == 0)
                next_state = SHOW_TIME;

            // Else remain in KEY_WAITED
            else
                next_state = KEY_WAITED;
        end

        
        // KEY_ENTRY state
        
        KEY_ENTRY : begin
            // If alarm button pressed → SET_ALARM_TIME
            if (alarm_button)
                next_state = SET_ALARM_TIME;

            // If time button pressed → SET_CURRENT_TIME
            else if (time_button)
                next_state = SET_CURRENT_TIME;

            // If timeout occurs → SHOW_TIME
            else if (time_out == 0)
                next_state = SHOW_TIME;

            // If key pressed → KEY_STORED
            else if (key != NOKEY)
                next_state = KEY_STORED;

            // Else remain in KEY_ENTRY
            else
                next_state = KEY_ENTRY;
        end

        
        // SET_ALARM_TIME state
        
        SET_ALARM_TIME :
            next_state = SHOW_TIME;

        
        // SET_CURRENT_TIME state
        
        SET_CURRENT_TIME :
            next_state = SHOW_TIME;

        
        // Default state
        
        default :
            next_state = SHOW_TIME;

    endcase
end


// Moore FSM Outputs


// Assert show_new_time when state is KEY_ENTRY, KEY_STORED or KEY_WAITED
assign show_new_time =
       (pre_state == KEY_ENTRY)  ||
       (pre_state == KEY_STORED) ||
       (pre_state == KEY_WAITED) ? 1'b1 : 1'b0;

// Assert show_a when state is SHOW_ALARM
assign show_a =
       (pre_state == SHOW_ALARM) ? 1'b1 : 1'b0;

// Assert load_new_a when state is SET_ALARM_TIME
assign load_new_a =
       (pre_state == SET_ALARM_TIME) ? 1'b1 : 1'b0;

// Assert load_new_c when state is SET_CURRENT_TIME
assign load_new_c =
       (pre_state == SET_CURRENT_TIME) ? 1'b1 : 1'b0;

// Assert reset_count when state is SET_CURRENT_TIME
assign reset_count =
       (pre_state == SET_CURRENT_TIME) ? 1'b1 : 1'b0;

// Assert shift when state is KEY_STORED
assign shift =
       (pre_state == KEY_STORED) ? 1'b1 : 1'b0;

endmodule


