`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/18 10:12:44
// Design Name: 
// Module Name: add_sub
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module add_sub (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    input        mode_select,
    output [7:0] sum,
    output       carry
);

    wire [7:0] w_b;

    sel_mode U_sel_mode (
        .b(b),
        .mode_select(mode_select),
        .o_b(w_b)
    );

    adder U_adder (
        .a(a),
        .b(w_b),
        .cin(0),
        .sum(sum),
        .carry(carry)
    );
endmodule

module sel_mode (
    input  [7:0] b,
    input        mode_select,
    output [7:0] o_b
);

    reg [7:0] temp_b;

    assign o_b = temp_b;

    always @(*) begin
        case (mode_select)
            1'b0: begin
                temp_b = b;
            end
            1'b1: begin
                temp_b = ~b + 1'b1;
            end
            default: temp_b = 0;
        endcase
    end

endmodule
