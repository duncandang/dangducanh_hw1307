module priority_encoder8to3 (
    input  wire [7:0] d,   // 8 input lines (D7 highest priority)
    output reg  [2:0] y,   // 3-bit binary output
    output reg  v          // Valid output
);
    always @(*) begin
        v = 1'b1;  // assume valid by default
        y = 3'b000;
        casez (d)
            8'b1???????: y = 3'b111; // d[7] is active (highest priority)
            8'b01??????: y = 3'b110; // d[6] is active
            8'b001?????: y = 3'b101; // d[5] is active
            8'b0001????: y = 3'b100; // d[4] is active
            8'b00001???: y = 3'b011; // d[3] is active
            8'b000001??: y = 3'b010; // d[2] is active
            8'b0000001?: y = 3'b001; // d[1] is active
            8'b00000001: y = 3'b000; // d[0] is active
            default: begin
                y = 3'b000;
                v = 1'b0; // no input active
            end
        endcase
    end
endmodule
