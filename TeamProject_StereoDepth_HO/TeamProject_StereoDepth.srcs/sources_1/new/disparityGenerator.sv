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


// module disparity_generator (
//     input logic        clk,
//     input logic        reset,
//     input logic [15:0] left_in,
//     input logic [15:0] right_in,

//     output logic [15:0] depth_out,
//     output logic        done
// );

//     localparam MAX_DISPARITY = 10;
//     localparam IMGWIDTH = 160;
//     localparam FOCAL_LENGTH = 600;
//     localparam BASELINE = 1;

//     logic [15:0] best_disp, best_score;
//     logic [15:0] disparity_score[0:MAX_DISPARITY-1];
//     logic [15:0] right_buffer[0:IMGWIDTH-1];
//     logic [7:0] x;

//     always_ff @(posedge clk, posedge reset) begin
//         if (reset) begin
//             best_disp <= 0;
//             best_score <= 16'hFFFF;
//             depth_out <= 0;
//             done <= 0;
//             x <= 0;
//             // Clear right_buffer when reset
//             for (int i = 0; i < IMGWIDTH; i++) begin
//                 right_buffer[i] <= 16'd0;
//             end
//         end else begin
//             // Shift the right_buffer contents
//             for (int i = 0; i < IMGWIDTH - 1; i++) begin
//                 right_buffer[i] <= right_buffer[i+1];
//             end
//             right_buffer[IMGWIDTH-1] <= right_in;

//             best_score <= 16'hFFFF;
//             // Compute disparity score for each disparity value
//             for (int d = 0; d < MAX_DISPARITY; d++) begin
//                 if (x - d >= 0) begin
//                     disparity_score[d] <= abs(left_in - right_buffer[x-d]);
//                 end else begin
//                     disparity_score[d] <= 16'hFFFF;
//                 end

//                 // Update best score and best disparity
//                 if (disparity_score[d] < best_score) begin
//                     best_score <= disparity_score[d];
//                     best_disp  <= d;
//                 end
//             end

//             // Calculate depth based on best disparity
//             if (best_disp != 0) begin
//                 depth_out <= (FOCAL_LENGTH * BASELINE) / best_disp;
//             end else begin
//                 depth_out <= 16'd0;
//             end

//             // Signal done when processing is complete
//             done <= (x == IMGWIDTH - 1);
//             if (x == IMGWIDTH - 1) begin
//                 x <= 0;
//             end else begin
//                 x <= x + 1;
//             end
//         end
//     end

//     function automatic [15:0] abs(input signed [15:0] x);
//         begin
//             abs = (x < 0) ? -x : x;
//         end
//     endfunction

// endmodule

// module disparity_generator (
//     input  logic        clk,
//     input  logic        reset,
//     input  logic [15:0] left_in,
//     input  logic [15:0] right_in,
//     output logic [15:0] depth_out,
//     output logic        done
// );

//     // Parameters
//     localparam MAX_DISPARITY = 10;
//     localparam IMGWIDTH = 160;
//     localparam FOCAL_LENGTH = 600;
//     localparam BASELINE = 1;

//     // Internal signals
//     logic [15:0] best_disp, best_score;
//     logic [15:0] disparity_score[0:MAX_DISPARITY-1];
//     logic [15:0] left_frame[0:IMGWIDTH-1];
//     logic [15:0] right_frame[0:IMGWIDTH-1];
//     logic [7:0] x;  // Pixel index
//     logic frame_ready;

//     // Frame buffer: Store a complete frame of input
//     always_ff @(posedge clk, posedge reset) begin
//         if (reset) begin
//             x <= 0;
//             frame_ready <= 0;
//         end else if (x < IMGWIDTH) begin
//             left_frame[x] <= left_in;
//             right_frame[x] <= right_in;
//             x <= x + 1;
//             frame_ready <= 0; // Make sure frame_ready is low during the frame capture
//         end else begin
//             frame_ready <= 1;  // Frame buffer is full
//             x <= 0;  // Reset x for next frame
//         end
//     end

//     // Disparity calculation
//     logic [7:0] current_x;  // Copy of x to prevent race conditions
//     always_ff @(posedge clk, posedge reset) begin
//         if (reset) begin
//             best_disp <= 0;
//             best_score <= 16'hFFFF;
//             depth_out <= 0;
//             done <= 0;
//             current_x <= 0;
//         end else if (frame_ready) begin
//             current_x  <= x;  // Use the copy of x
//             // Initialize for new row
//             best_score <= 16'hFFFF;

//             // Compute disparity scores for the current pixel
//             for (int d = 0; d < MAX_DISPARITY; d++) begin
//                 if (current_x >= d) begin
//                     disparity_score[d] <=
//                         abs(left_frame[current_x] - right_frame[current_x-d]);
//                 end else begin
//                     disparity_score[d] <= 16'hFFFF;  // Out of bounds penalty
//                 end
//             end

//             // Find the best disparity
//             for (int d = 0; d < MAX_DISPARITY; d++) begin
//                 if (disparity_score[d] < best_score) begin
//                     best_score <= disparity_score[d];
//                     best_disp  <= d;
//                 end
//             end

//             // Compute depth
//             if (best_disp > 0) begin
//                 depth_out <= (FOCAL_LENGTH * BASELINE) / best_disp;
//             end else begin
//                 depth_out <= 16'd0;  // Handle zero disparity case
//             end

//             // Signal completion of processing
//             if (current_x == IMGWIDTH - 1) begin
//                 done <= 1;
//                 frame_ready <= 0;  // Reset frame ready for the next frame
//                 current_x <= 0;
//             end else begin
//                 done <= 0;
//                 current_x <= current_x + 1;
//             end
//         end
//     end

//     // Absolute value function
//     function automatic [15:0] abs(input signed [15:0] x);
//         begin
//             abs = (x < 0) ? -x : x;
//         end
//     endfunction

// endmodule


// module disparity_generator (
//     input  logic        clk,
//     input  logic        reset,
//     input  logic        Hsync,
//     // write side
//     input  logic        wclk1,
//     input  logic        we1,
//     input  logic [14:0] wAddr1,
//     input  logic [15:0] wData1,
//     // write side
//     input  logic        wclk2,
//     input  logic        we2,
//     input  logic [14:0] wAddr2,
//     input  logic [15:0] wData2,
//     // read side for VGA
//     // input  logic [14:0] rAddr,
//     // output logic [ 5:0] rData
//     input  logic        rclk,
//     input  logic        oe,
//     input  logic [14:0] rAddr,
//     output logic [ 5:0] rData
// );
//     // logic [5:0] mem_L[0:160-1];
//     logic [5:0] mem_L;
//     logic [5:0] mem_R[0:160-1];

//     // logic [5:0] prv_mem_L[0:160-1];
//     logic [5:0] prv_mem_L;
//     logic [5:0] prv_mem_R[0:160-1];

//     logic [1:0] state_reg, state_next;
//     logic read_en_reg, read_en_next;


//     localparam IDLE = 0, STATE0 = 1, STATE1 = 2, STATE2 = 3;

//     // assign rData = prv_mem_R[rAddr];
//     always_ff @(posedge rclk) begin
//         if (oe && read_en_reg) begin
//             // if (oe) begin
//             // rData <= (prv_mem_R[rAddr] > 20) ? 6'b000000 : 6'b111111;
//             rData <= prv_mem_R[rAddr];
//         end else begin
//             rData <= 0;
//         end
//     end

//     always_ff @(posedge clk, posedge reset) begin
//         if (reset) begin
//             state_reg   <= 0;
//             // for (int i = 0; i < 160; i++) begin
//             //     mem_R[i]     <= 0;
//             //     prv_mem_R[i] <= 0;
//             // end
//             // mem_L       <= 0;
//             // prv_mem_L   <= 0;
//             read_en_reg <= 0;
//         end else begin
//             state_reg   <= state_next;
//             read_en_reg <= read_en_next;
//         end
//     end

//     always_ff @(posedge wclk1) begin
//         if (wAddr1 == 79 && we1) begin
//             // mem_L = (wData1[15:11]*299 + wData1[10:5]*587 + wData1[4:0]*114) / 1000;
//             mem_L <= wData1[15:10];
//         end
//         // mem_L[wAddr1] = (wData1[15:11]*299 + wData1[10:5]*587 + wData1[4:0]*114) / 1000;
//     end

//     always_ff @(posedge wclk2) begin
//         if (we2) begin
//             // mem_R[wAddr2] = (wData2[15:11]*299 + wData2[10:5]*587 + wData2[4:0]*114) / 1000;
//             mem_R[wAddr2%160] <= wData2[15:10];
//         end
//     end

//     always_comb begin
//         state_next   = state_reg;
//         read_en_next = read_en_reg;
//         case (state_reg)
//             IDLE: begin
//                 prv_mem_L = mem_L;
//                 prv_mem_R = mem_R;
//                 if (wAddr1 % 159 == 0 && wAddr1 > 0) begin
//                     state_next   = STATE0;
//                     read_en_next = 0;
//                 end
//             end
//             STATE0: begin
//                 for (int i = 0; i < 160; i++) begin
//                     prv_mem_R[i] = (prv_mem_L > prv_mem_R[i]) ? (prv_mem_L - prv_mem_R[i]) : (prv_mem_R[i] - prv_mem_L);
//                 end
//                 read_en_next = 1;
//                 if (!Hsync) begin
//                     state_next = IDLE;
//                 end else begin
//                     state_next = STATE0;
//                 end
//             end
//             // STATE1: begin

//             // end
//             // STATE2: begin

//             // end
//         endcase
//     end
//     ila_0 U_ila_0 (
//         .clk    (clk),                    // input wire clk
//         .probe0 (wclk1),                  // input wire [0:0]  probe0  
//         .probe1 (wAddr1),                 // input wire [14:0]  probe1 
//         .probe2 (wData1),                 // input wire [15:0]  probe2 
//         .probe3 (wclk2),                  // input wire [0:0]  probe3 
//         .probe4 (wAddr2),                 // input wire [14:0]  probe4 
//         .probe5 (wData2),                 // input wire [15:0]  probe5 
//         .probe6 (rclk),                   // input wire [0:0]  probe6 
//         .probe7 (oe),                     // input wire [0:0]  probe7 
//         .probe8 (rAddr),                  // input wire [14:0]  probe8 
//         .probe9 (rData),                  // input wire [5:0]  probe9 
//         .probe10(mem_L),                  // input wire [5:0]  probe10 
//         .probe11(mem_R[wAddr2%160]),      // input wire [5:0]  probe11 
//         .probe12(prv_mem_L),              // input wire [5:0]  probe12 
//         .probe13(prv_mem_R[wAddr2%160]),  // input wire [5:0]  probe13 
//         .probe14(state_reg),              // input wire [1:0]  probe14 
//         .probe15(read_en_reg),            // input wire [0:0]  probe15
//         .probe16(Hsync)                   // input wire [0:0]  probe16
//     );
// endmodule


module disparity_generator (
    input  logic        clk,
    input  logic        reset,
    // input  logic        Hsync,
    // write side
    input  logic        wclk1,
    input  logic        we1,
    input  logic [14:0] wAddr1,
    input  logic [15:0] wData1,
    // write side
    input  logic        wclk2,
    input  logic        we2,
    input  logic [14:0] wAddr2,
    input  logic [15:0] wData2,
    // read side for VGA
    input  logic        rclk,
    input  logic        oe,
    input  logic [14:0] rAddr,
    output logic [ 5:0] rData
);
    logic [5:0] mem_L[0:160-1];
    logic [5:0] mem_R[0:160-1];

    logic [5:0] prv_mem_L[0:160-1];
    logic [5:0] prv_mem_R[0:160-1];

    logic [1:0] state_reg, state_next;
    logic read_en_reg, read_en_next;
    logic [5:0] temp1;
    logic [5:0] temp2;
    logic [5:0] temp3;
    logic [5:0] temp4;
    logic [5:0] temp5;
    logic [5:0] temp_mem[0:160-1];
    // logic [6:0] j_reg, j_next;


    localparam IDLE = 0, STATE0 = 1, STATE1 = 2, STATE2 = 3;

    always_ff @(posedge rclk) begin
        if (oe && read_en_reg) begin
            rData <= temp_mem[rAddr];
        end else begin
            rData <= 0;
        end
    end

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state_reg   <= 0;
            read_en_reg <= 0;
            temp1       <= 0;
            temp2       <= 0;
            temp3       <= 0;
            temp4       <= 0;
            temp5       <= 0;
            // j_reg       <= 0;
        end else begin
            state_reg   <= state_next;
            read_en_reg <= read_en_next;
            // j_reg       <= j_next;
        end
    end

    always_ff @(posedge wclk1) begin
        if (we1) begin
            mem_L[wAddr2%160] <= wData1[15:10];
        end
    end

    always_ff @(posedge wclk2) begin
        if (we2) begin
            mem_R[wAddr2%160] <= wData2[15:10];
        end
    end


    always_comb begin
        state_next   = state_reg;
        read_en_next = read_en_reg;
        // j_next       = j_reg;
        case (state_reg)
            IDLE: begin
                prv_mem_L = mem_L;
                prv_mem_R = mem_R;
                if (wAddr1 % 159 == 0 && wAddr1 > 0) begin
                    state_next   = STATE0;
                    read_en_next = 0;
                end
                // if (j_reg == 1)
                // focal length * baseline / disparity = z() (depth)
            end
            STATE0: begin
                for (int j = 0; j < 160; j++) begin
                    temp1 = (prv_mem_L[j] > prv_mem_R[j]) ? (prv_mem_L[j] - prv_mem_R[j]) : (prv_mem_R[j] - prv_mem_L[j]); // Right data' 1st data. 
                    temp2 = (prv_mem_L[j] > prv_mem_R[j+1]) ? (prv_mem_L[j] - prv_mem_R[j+1]) : (prv_mem_R[j+1] - prv_mem_L[j]);       // i
                    temp3 = (prv_mem_L[j] > prv_mem_R[j+2]) ? (prv_mem_L[j] - prv_mem_R[j+2]) : (prv_mem_R[j+2] - prv_mem_L[j]);       // i
                    temp4 = (prv_mem_L[j] > prv_mem_R[j+3]) ? (prv_mem_L[j] - prv_mem_R[j+3]) : (prv_mem_R[j+3] - prv_mem_L[j]);       // i
                    temp5 = (prv_mem_L[j] > prv_mem_R[j+4]) ? (prv_mem_L[j] - prv_mem_R[j+4]) : (prv_mem_R[j+4] - prv_mem_L[j]);       // i
                    if (temp1 < temp2) begin
                        if (temp1 < temp3) begin
                            if (temp1 < temp4) begin
                                if (temp1 < temp5) begin
                                    temp_mem[j] = 600 * 0.1 / 1;
                                end else begin
                                    temp_mem[j] = 600 * 0.1 / 5;
                                end
                            end else begin
                                if (temp4 < temp5) begin
                                    temp_mem[j] = 600 * 0.1 / 4;
                                end else begin
                                    temp_mem[j] = 600 * 0.1 / 5;
                                end
                            end
                        end else begin
                            if (temp3 < temp4) begin
                                if (temp3 < temp5) begin
                                    temp_mem[j] = 600 * 0.1 / 3;
                                end else begin
                                    temp_mem[j] = 600 * 0.1 / 5;
                                end
                            end else begin
                                if (temp4 < temp5) begin
                                    temp_mem[j] = 600 * 0.1 / 4;
                                end else begin
                                    temp_mem[j] = 600 * 0.1 / 5;
                                end
                            end
                        end
                    end else begin
                        if (temp2 < temp3) begin
                            if (temp2 < temp4) begin
                                if (temp2 < temp5) begin
                                    temp_mem[j] = 600 * 0.1 / 2;
                                end else begin
                                    temp_mem[j] = 600 * 0.1 / 5;
                                end
                            end else begin
                                if (temp4 < temp5) begin
                                    temp_mem[j] = 600 * 0.1 / 4;
                                end else begin
                                    temp_mem[j] = 600 * 0.1 / 5;
                                end
                            end
                        end else begin
                            if (temp3 < temp4) begin
                                if (temp3 < temp5) begin
                                    temp_mem[j] = 600 * 0.1 / 3;
                                end else begin
                                    temp_mem[j] = 600 * 0.1 / 5;
                                end
                            end else begin
                                if (temp4 < temp5) begin
                                    temp_mem[j] = 600 * 0.1 / 4;
                                end else begin
                                    temp_mem[j] = 600 * 0.1 / 5;
                                end
                            end
                        end
                    end
                end
                // j_next = j_reg + 1;
                read_en_next = 1;
                state_next   = IDLE;
            end
        endcase
    end
endmodule
