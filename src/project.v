/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

tt_um_example user_project (
`ifdef GL_TEST
    input  wire VPWR,
    input  wire VGND,
`endif
    input  wire       clk,
    input  wire       rst_n,
    input  wire       ena,

    input  wire [7:0] ui_in,
    input  wire [7:0] uio_in,

    output wire [7:0] uo_out,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe
);

    // Inputs
    wire [3:0] A;
    wire [3:0] B;
    wire [3:0] OP;

    assign A  = ui_in[3:0];
    assign OP = ui_in[7:4];
    assign B  = uio_in[3:0];

    // Internal signals
    reg [3:0] result;
    reg carry;
    reg overflow;

    reg [4:0] temp;

    // ALU
    always @(*) begin

        // Default values
        result   = 4'b0000;
        carry    = 1'b0;
        overflow = 1'b0;
        temp     = 5'b00000;

        case (OP)

            // 0000 = Addition
            4'b0000: begin
                temp   = A + B;
                result = temp[3:0];
                carry  = temp[4];

                // Signed overflow
                overflow = (~(A[3] ^ B[3])) &
                           (result[3] ^ A[3]);
            end

            // 0001 = Subtraction
            4'b0001: begin
                result = A - B;

                // Signed overflow
                overflow = (A[3] ^ B[3]) &
                           (result[3] ^ A[3]);
            end

            // 0010 = AND
            4'b0010: begin
                result = A & B;
            end

            // 0011 = OR
            4'b0011: begin
                result = A | B;
            end

            // 0100 = XOR
            4'b0100: begin
                result = A ^ B;
            end

            // 0101 = NOT A
            4'b0101: begin
                result = ~A;
            end

            // 0110 = Left shift
            4'b0110: begin
                result = A << 1;
            end

            // 0111 = Right shift
            4'b0111: begin
                result = A >> 1;
            end

            // Anything else
            default: begin
                result   = 4'b0000;
                carry    = 1'b0;
                overflow = 1'b0;
            end

        endcase
    end

    // Output result
    assign uo_out[3:0] = result;

    // Carry flag
    assign uo_out[4] = carry;

    // Zero flag
    assign uo_out[5] = (result == 4'b0000);

    // Overflow flag
    assign uo_out[6] = overflow;

    // Unused output
    assign uo_out[7] = 1'b0;

    // We are not using the bidirectional outputs
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

endmodule
