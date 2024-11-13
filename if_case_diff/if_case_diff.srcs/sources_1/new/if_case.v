`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/13 10:23:52
// Design Name: 
// Module Name: if_case
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


module if_case (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [1:0] sel,
    output [3:0] muxout
);

    conop_out U_conop_out (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .muxout(muxout)
    );

endmodule

module if_out (
    input      [3:0] a,
    input      [3:0] b,
    input      [3:0] c,
    input      [3:0] d,
    input      [1:0] sel,
    output reg [3:0] muxout
);


    always @(sel, a, b, c, d) begin
        if (sel == 2'b00) muxout = a;
        else if (sel == 2'b01) muxout = b;
        else if (sel == 2'b10) muxout = c;
        else if (sel == 2'b11) muxout = d;
        else muxout = 4'bx;
    end
endmodule

module case_out (
    input      [3:0] a,
    input      [3:0] b,
    input      [3:0] c,
    input      [3:0] d,
    input      [1:0] sel,
    output reg [3:0] muxout
);


    always @(sel, a, b, c, d) begin
        case (sel)
            0: muxout = a;
            1: muxout = b;
            2: muxout = c;
            3: muxout = d;
            default: muxout = 4'bx;
        endcase
    end

endmodule

module conop_out (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [1:0] sel,
    output [3:0] muxout
);

    assign muxout = (sel == 0) ? a : 
                    (sel == 1) ? b : 
                    (sel == 2) ? c : 
                    (sel == 3) ? d : 4'bx;


endmodule
