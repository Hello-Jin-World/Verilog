`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/05 13:28:43
// Design Name: 
// Module Name: fnd_controller
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

module fnd_controller(
    input [1:0] fndsel,
    input [3:0] bcddata,
    output [3:0] fndcom,
    output [7:0] fndfont
    );

    decoder_2x4 U_decoder_2x4(
        .switch_in(fndsel),
        .switch_out(fndcom)
    );

    BCDtoSEG_decoder U_BCDtoSEG (
        .bcd(bcddata),
        .seg(fndfont)
    );
endmodule 

module decoder_2x4(
    input [1:0] switch_in,
    output reg [4:0] switch_out
    );

    always @(switch_in) begin
        case (switch_in)
            2'b00 : switch_out = 4'b1110;
            2'b01 : switch_out = 4'b1101;
            2'b10 : switch_out = 4'b1011;
            2'b11 : switch_out = 4'b0111;
            default: switch_out = 4'b1111;
        endcase
    end
endmodule


module BCDtoSEG_decoder(
    input [3:0] bcd,
    output reg [7:0] seg

    );

    always @(bcd) begin
        case (bcd)
            4'h0 : seg = 8'hc0;
            4'h1 : seg = 8'hf9;
            4'h2 : seg = 8'ha4;
            4'h3 : seg = 8'hb0;
            4'h4 : seg = 8'h99;
            4'h5 : seg = 8'h92;
            4'h6 : seg = 8'h82;
            4'h7 : seg = 8'hf8;
            4'h8 : seg = 8'h80;
            4'h9 : seg = 8'h90;
            4'ha : seg = 8'h88;
            4'hb : seg = 8'h83;
            4'hc : seg = 8'hc6;
            4'hd : seg = 8'ha1;
            4'he : seg = 8'h86;
            4'hf : seg = 8'h8e;
            default: seg = 8'hff;
        endcase
    end
endmodule
