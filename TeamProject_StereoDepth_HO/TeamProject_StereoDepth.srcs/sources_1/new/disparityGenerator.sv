`timescale 1ns / 1ps

//module fifo_buffer #(
//    parameter WIDTH = 16,    
//    parameter DEPTH = 256   
//)(
//    input logic clk_vga,      
//    input logic clk_internal,
//    input logic reset,        
//    input logic [WIDTH-1:0] left_in,  
//    input logic [WIDTH-1:0] right_in, 
//    input logic push,        
//    output logic [WIDTH-1:0] left_out, 
//    output logic [WIDTH-1:0] right_out, 
//    output logic fifo_empty,  
//    output logic fifo_full    
//);

//    logic [WIDTH-1:0] fifo_mem_left [0:DEPTH-1]; 
//    logic [WIDTH-1:0] fifo_mem_right [0:DEPTH-1]; 
//    logic [7:0] write_ptr;  
//    logic [7:0] read_ptr;   

//    always_ff @(posedge clk_vga or posedge reset) begin
//        if (reset) begin
//            write_ptr <= 0;
//        end else if (push && !fifo_full) begin
//            fifo_mem_left[write_ptr] <= left_in;
//            fifo_mem_right[write_ptr] <= right_in;
//            write_ptr <= (write_ptr + 1) % DEPTH; 
//        end
//    end

//    always_ff @(posedge clk_internal or posedge reset) begin
//        if (reset) begin
//            read_ptr <= 0;
//            left_out<= 0;
//            right_out <= 0;
//        end else if (!fifo_empty) begin
//            left_out <= fifo_mem_left[read_ptr];
//            right_out <= fifo_mem_right[read_ptr];
//            read_ptr <= (read_ptr + 1) % DEPTH;
//        end
//    end

//    assign fifo_empty = (write_ptr == read_ptr);
//    assign fifo_full = ((write_ptr + 1) % DEPTH == read_ptr);

//endmodule


//module disparity_generator (
//    input logic clk_internal,  
//    input logic clk_vga,       
//    input logic reset,         
//    input logic [15:0] left_in,  
//    input logic [15:0] right_in, 

//    output logic [15:0] depth_out, 
//    output logic done              
//);

//    // Parameters
//    localparam MAX_DISPARITY = 15;
//    localparam IMGWIDTH = 160;
//    localparam IMGHEIGHT = 120;
//    localparam FOCAL_LENGTH = 1000; 
//    localparam BASELINE = 100;      

//    logic [15:0] best_disp;        
//    logic [15:0] best_score;      
//    logic [15:0] disparity_score [0:MAX_DISPARITY-1]; 
//    logic fifo_empty;              
//    logic fifo_push;                

//    logic [15:0] right_buffer [0:IMGWIDTH-1];  
//    int x;  
//    logic [15:0] disparity_fifo_out; 
//    logic [15:0] depth_fifo_out;    


//    fifo_buffer #( .WIDTH(16), .DEPTH(256) ) fifo_inst (
//        .clk_vga(clk_vga),
//        .clk_internal(clk_internal),
//        .reset(reset),
//        .left_in(left_in),
//        .right_in(right_in),
//        .push(1'b1),  
//        .left_out(fifo_left_out),  
//        .right_out(fifo_right_out),
//        .fifo_empty(fifo_empty),
//        .fifo_full()
//    );

//    fifo_buffer #( .WIDTH(16), .DEPTH(256) ) disparity_fifo (
//        .clk_vga(clk_vga),
//        .clk_internal(clk_internal),
//        .reset(reset),
//        .left_in(depth_fifo_out), 
//        .right_in(16'b0),     
//        .push(fifo_push),     
//        .left_out(depth_out),  
//        .right_out(),         
//        .fifo_empty(),        
//        .fifo_full()          
//    );

//    always_ff @(posedge clk_internal or posedge reset) begin
//        if (reset) begin
//            best_disp <= 0;
//            best_score <= 16'hFFFF;
//            depth_out <= 0;
//            done <= 0;
//            fifo_push <= 0;
//            x <= 0;  
//        end else begin
//            if (!fifo_empty) begin
//                best_score <= 16'hFFFF;
//                best_disp <= 0;

//                for (int i = 0; i < IMGWIDTH - 1; i++) begin
//                    right_buffer[i] <= right_buffer[i + 1];  
//                end
//                right_buffer[IMGWIDTH - 1] <= fifo_right_out;  


//                for (int d = 0; d < MAX_DISPARITY; d++) begin
//                    if (x - d >= 0) begin  
//                        disparity_score[d] <= abs(fifo_left_out - right_buffer[x - d]);
//                    end else begin
//                        disparity_score[d] <= 16'hFFFF; 
//                    end
//                end

//                best_score <= 16'hFFFF;
//                for (int d = 0; d < MAX_DISPARITY; d++) begin
//                    if (disparity_score[d] < best_score) begin
//                        best_score <= disparity_score[d];
//                        best_disp <= d;
//                    end
//                end

//                if (best_disp != 0) begin
//                    depth_out <= (FOCAL_LENGTH * BASELINE) / best_disp;
//                end else begin
//                    depth_out <= 16'hFFFF;  
//                end

//                fifo_push <= 1;
//                done <= 1;

//                x <= x + 1;
//            end else begin
//                fifo_push <= 0; 
//            end
//        end
//    end

//    function automatic [15:0] abs(input [15:0] x);
//        begin
//            if (x < 0) 
//                abs = -x;
//            else
//                abs = x;
//        end
//    endfunction

//endmodule


//module fifo_buffer #(
//    parameter WIDTH = 16,    
//    parameter DEPTH = 256   
//)(
//    input logic clk_vga,      
//    input logic clk_internal,
//    input logic reset,        
//    input logic [WIDTH-1:0] left_in,  
//    input logic [WIDTH-1:0] right_in, 
//    input logic push,        
//    output logic [WIDTH-1:0] left_out, 
//    output logic [WIDTH-1:0] right_out, 
//    output logic fifo_empty,  
//    output logic fifo_full    
//);

//    reg [WIDTH-1:0] fifo_mem_left [0:DEPTH-1]; 
//    reg [WIDTH-1:0] fifo_mem_right [0:DEPTH-1]; 
//    logic [7:0] write_ptr;  
//    logic [7:0] read_ptr;   

//    always_ff @(posedge clk_internal , posedge reset) begin
//        if (reset) begin
//            write_ptr <= 0;
//        end else if (push && !fifo_full) begin
//            fifo_mem_left[write_ptr] <= left_in;
//            fifo_mem_right[write_ptr] <= right_in;
//            write_ptr <= (write_ptr + 1) % DEPTH; 
//        end
//    end

//    always_ff @(posedge clk_vga , posedge reset) begin
//        if (reset) begin
//            read_ptr <= 0;
//            left_out <= 0;
//            right_out <= 0;
//        end else if (!fifo_empty) begin
//            left_out <= fifo_mem_left[read_ptr];
//            right_out <= fifo_mem_right[read_ptr];
//            read_ptr <= (read_ptr + 1) % DEPTH;
//        end
//    end

//    assign fifo_empty = (write_ptr == read_ptr);
//    assign fifo_full = ((write_ptr + 1) % DEPTH == read_ptr);

//endmodule


//module disparity_generator (
//    input logic clk_internal,  
//    input logic clk_vga,       
//    input logic reset,         
//    input logic [15:0] left_in,  
//    input logic [15:0] right_in, 

//    output logic [15:0] depth_out, 
//    output logic done               
//);

//    // Parameters
//    localparam MAX_DISPARITY = 15;
//    localparam IMGWIDTH = 160;
//    localparam IMGHEIGHT = 120;
//    localparam FOCAL_LENGTH = 1000; 
//    localparam BASELINE = 100;      

//    logic [15:0] best_disp;        
//    logic [15:0] best_score, fifo_left_out,  fifo_right_out;      
//    logic [15:0] disparity_score [0:MAX_DISPARITY-1]; 
//    logic fifo_empty;              
//    logic fifo_push;            

//    logic [15:0] right_buffer [0:IMGWIDTH-1];  
//    int x;  
//    logic [15:0] disparity_fifo_out; 
//    logic [15:0] depth_fifo_out;     

//    fifo_buffer #( .WIDTH(16), .DEPTH(256) ) fifo_inst (
//        .clk_vga(clk_vga),
//        .clk_internal(clk_internal),
//        .reset(reset),
//        .left_in(left_in),
//        .right_in(right_in),
//        .push(1'b1),  
//        .left_out(fifo_left_out),  
//        .right_out(fifo_right_out),
//        .fifo_empty(fifo_empty),
//        .fifo_full()
//    );

//    fifo_buffer #( .WIDTH(16), .DEPTH(256) ) disparity_fifo (
//        .clk_vga(clk_vga),
//        .clk_internal(clk_internal),
//        .reset(reset),
//        .left_in(depth_fifo_out), 
//        .right_in(16'b0),     
//        .push(fifo_push),     
//        .left_out(depth_out),  
//        .right_out(),         
//        .fifo_empty(),        
//        .fifo_full()          
//    );

//    always_ff @(posedge clk_internal or posedge reset) begin
//        if (reset) begin
//            best_disp <= 0;
//            best_score <= 16'hFFFF;
//            depth_fifo_out <= 0;
//            done <= 0;
//            fifo_push <= 0;
//            x <= 0;  
//        end else begin
//            if (!fifo_empty) begin
//                best_score <= 16'hFFFF;
//                best_disp <= 0;

//                for (int i = 0; i < IMGWIDTH - 1; i++) begin
//                    right_buffer[i] <= right_buffer[i + 1];  
//                end
//                right_buffer[IMGWIDTH - 1] <= fifo_right_out;  

//                for (int d = 0; d < MAX_DISPARITY; d++) begin
//                    if (x - d >= 0) begin  
//                        disparity_score[d] <= abs(fifo_left_out - right_buffer[x - d]);
//                    end else begin
//                        disparity_score[d] <= 16'hFFFF; 
//                    end
//                end

//                best_score <= 16'hFFFF;
//                for (int d = 0; d < MAX_DISPARITY; d++) begin
//                    if (disparity_score[d] < best_score) begin
//                        best_score <= disparity_score[d];
//                        best_disp <= d;
//                    end
//                end

//                if (best_disp != 0) begin
//                    depth_fifo_out <= (FOCAL_LENGTH * BASELINE) / best_disp;
//                end else begin
//                    depth_fifo_out <= 16'hFFFF;  
//                end

//                fifo_push <= 1;
//                done <= 1;
//                x <= x + 1;
//            end else begin
//                fifo_push <= 0; 
//            end
//        end
//    end

//    function automatic [15:0] abs(input [15:0] x);
//        begin
//            if (x < 0) 
//                abs = -x;
//            else
//                abs = x;
//        end
//    endfunction

//endmodule


module disparity_generator (
    input logic        clk,
    input logic        reset,
    input logic [15:0] left_in,
    input logic [15:0] right_in,

    output logic [15:0] depth_out,
    output logic        done
);

    localparam MAX_DISPARITY = 10;
    localparam IMGWIDTH = 160;
    localparam FOCAL_LENGTH = 700;
    localparam BASELINE = 1;

    logic [15:0] best_disp, best_score;
    logic [15:0] disparity_score[0:MAX_DISPARITY-1];
    logic [15:0] right_buffer[0:IMGWIDTH-1];
    logic [7:0] x;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            best_disp <= 0;
            best_score <= 16'hFFFF;
            depth_out <= 0;
            done <= 0;
            x <= 0;
            // Clear right_buffer when reset
            for (int i = 0; i < IMGWIDTH; i++) begin
                right_buffer[i] <= 16'd0;
            end
        end else begin
            // Shift the right_buffer contents
            for (int i = 0; i < IMGWIDTH - 1; i++) begin
                right_buffer[i] <= right_buffer[i+1];
            end
            right_buffer[IMGWIDTH-1] <= right_in;

            best_score <= 16'hFFFF;
            // Compute disparity score for each disparity value
            for (int d = 0; d < MAX_DISPARITY; d++) begin
                if (x - d >= 0) begin
                    disparity_score[d] <= abs(left_in - right_buffer[x-d]);
                end else begin
                    disparity_score[d] <= 16'hFFFF;
                end

                // Update best score and best disparity
                if (disparity_score[d] < best_score) begin
                    best_score <= disparity_score[d];
                    best_disp  <= d;
                end
            end

            // Calculate depth based on best disparity
            if (best_disp != 0) begin
                depth_out <= (FOCAL_LENGTH * BASELINE) / best_disp;
            end else begin
                depth_out <= 16'd0;
            end

            // Signal done when processing is complete
            done <= (x == IMGWIDTH - 1);
            if (x == IMGWIDTH - 1) begin
                x <= 0;
            end else begin
                x <= x + 1;
            end
        end
    end

    function automatic [15:0] abs(input signed [15:0] x);
        begin
            abs = (x < 0) ? -x : x;
        end
    endfunction

endmodule
