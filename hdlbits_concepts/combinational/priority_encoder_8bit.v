// 8-bit priority encoder using casez
// Reports the position of the least significant '1' bit.
// If no bits are high, output position is 0.

module priority_encoder_8bit (
    input  [7:0] in,
    output reg [2:0] pos
);

    always @(*) begin
        casez (in)
            8'bzzzzzzz1: pos = 3'd0;
            8'bzzzzzz1z: pos = 3'd1;
            8'bzzzzz1zz: pos = 3'd2;
            8'bzzzz1zzz: pos = 3'd3;
            8'bzzz1zzzz: pos = 3'd4;
            8'bzz1zzzzz: pos = 3'd5;
            8'bz1zzzzzz: pos = 3'd6;
            8'b1zzzzzzz: pos = 3'd7;
            default:     pos = 3'd0;
        endcase
    end

endmodule
