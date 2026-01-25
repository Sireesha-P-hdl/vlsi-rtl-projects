//------------------------------------------------------------------------------
// Module: thermostat_controller
// Description: Controls heater, air conditioner, and blower fan
// based on temperature conditions, operating mode, and user request.
//------------------------------------------------------------------------------
module thermostat_controller (
    input  too_cold,
    input  too_hot,
    input  mode,      // 1 = heating mode, 0 = cooling mode
    input  fan_on,    // Manual fan request
    output heater,
    output aircon,
    output fan
);

    // Heater is enabled only in heating mode when it is too cold
    assign heater = mode & too_cold;

    // Air conditioner is enabled only in cooling mode when it is too hot
    assign aircon = ~mode & too_hot;

    // Fan runs when heater, air conditioner, or manual fan is enabled
    assign fan = fan_on | heater | aircon;

endmodule
