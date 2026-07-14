/*
 * 8-to-3 Priority Encoder for Tiny Tapeout
 * Author: Dang duc anh
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_dda_sys_8to3prioencode (
    input  wire [7:0] ui_in,    // Dedicated inputs: d[7:0]
    output wire [7:0] uo_out,   // Dedicated outputs: [7:4] unused, [3] v, [2:0] y
    input  wire [7:0] uio_in,   // Bidirectional input path
    output wire [7:0] uio_out,  // Bidirectional output path
    output wire [7:0] uio_oe,   // Bidirectional output enable
    input  wire       ena,      // Design enable
    input  wire       clk,      // Clock (unused)
    input  wire       rst_n     // Active-low reset (unused)
);

    // Input mapping
    wire [7:0] d = ui_in;

    // Internal registers for priority encoder logic
    reg [2:0] y;
    reg v;

    // Priority encoder combinatorial logic
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

    // Output mapping:
    // uo_out[2:0] = y (3-bit binary output)
    // uo_out[3]   = v (Valid output)
    // uo_out[7:4] = unused (set to 0)
    assign uo_out = {4'b0000, v, y};

    // Bidirectional pins are unused
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // Mark unused inputs to avoid lint warnings
    wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule

`default_nettype wire
