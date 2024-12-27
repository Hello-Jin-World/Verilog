`timescale 1ns / 1ps

module ISP_P (
    input  logic        clk,
    input  logic        reset,
    input  logic [ 9:0] x,
    input  logic [ 9:0] y,
    input  logic        h_sync,
    input  logic        v_sync,
    // Before upscale data
    input  logic [15:0] RGBdata,
    output logic [16:0] addr,
    // VGA out port
    input  logic        rclk,
    input  logic        oe,
    output logic [15:0] rData
);

    // logic [2:0] state_reg, state_next;
    logic [15:0] video_mem [0:640-1];
    logic [15:0] video_copy[0:640-1];
    logic [15:0] video_reg;
    logic [9:0] i_reg, i_next;
    // logic [15:0] rData_reg, rData_next;

    always_ff @(posedge rclk) begin
        // rData_reg <= rData_next;
        if (oe) begin
            rData <= (y[0]) ? video_mem[x] : video_copy[x];
        end else begin
            rData <= 0;
        end
    end

    assign addr = x[9:1] + 320 * y[9:1];

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            i_reg     <= 0;
            video_reg <= 0;
        end else begin
            video_reg <= RGBdata;
            i_reg     <= i_next;
        end
    end

    always_comb begin
        i_next = i_reg;
        if (!h_sync) begin
            i_next     = 0;
            video_copy = video_mem;
        end else begin
            if (video_reg != RGBdata) begin
                video_mem[i_reg]   = video_reg;
                i_next             = i_reg + 2;
                video_mem[i_reg+1] = (video_reg + RGBdata) / 2;
                // video_mem[i_reg+1] = {
                // (video_reg[15:12] + RGBdata[15:12]) / 2,
                // (video_reg[10:7] + RGBdata[10:7]) / 2,
                // (video_reg[4:1] + RGBdata[4:1]) / 2
                // };
            end
        end
    end

endmodule
