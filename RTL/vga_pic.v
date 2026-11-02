`timescale 1ns/1ns
module vga_pic(
    input  wire        vga_clk,
    input  wire        sys_rst_n,
    input  wire [9:0]  pix_x,
    input  wire [9:0]  pix_y,
    output reg  [15:0] pix_data
);

    localparam [15:0] WHITE = 16'hFFFF;  // 字符颜色
    localparam [15:0] GREEN = 16'h07E0;  // 背景颜色：纯绿

    localparam [9:0] M_X0 = 10'd144;
    localparam [9:0] U_X0 = 10'd240;
    localparam [9:0] S_X0 = 10'd336;
    localparam [9:0] T_X0 = 10'd432;
    localparam [9:0] Y0   = 10'd208;
    localparam [9:0] BOX  = 10'd64;

    localparam [7:0] M_Row_0 = 8'b1100_0011;
    localparam [7:0] M_Row_1 = 8'b1110_0111;
    localparam [7:0] M_Row_2 = 8'b1111_1111;
    localparam [7:0] M_Row_3 = 8'b1101_1011;
    localparam [7:0] M_Row_4 = 8'b1100_0011;
    localparam [7:0] M_Row_5 = 8'b1100_0011;
    localparam [7:0] M_Row_6 = 8'b1100_0011;
    localparam [7:0] M_Row_7 = 8'b1100_0011;

    localparam [7:0] U_Row_0 = 8'b1100_0011;
    localparam [7:0] U_Row_1 = 8'b1100_0011;
    localparam [7:0] U_Row_2 = 8'b1100_0011;
    localparam [7:0] U_Row_3 = 8'b1100_0011;
    localparam [7:0] U_Row_4 = 8'b1100_0011;
    localparam [7:0] U_Row_5 = 8'b1100_0011;
    localparam [7:0] U_Row_6 = 8'b1110_0111;
    localparam [7:0] U_Row_7 = 8'b0111_1110;

    localparam [7:0] S_Row_0 = 8'b0111_1110;
    localparam [7:0] S_Row_1 = 8'b1110_0111;
    localparam [7:0] S_Row_2 = 8'b1110_0000;
    localparam [7:0] S_Row_3 = 8'b0111_1110;
    localparam [7:0] S_Row_4 = 8'b0000_0111;
    localparam [7:0] S_Row_5 = 8'b0000_0111;
    localparam [7:0] S_Row_6 = 8'b1110_0111;
    localparam [7:0] S_Row_7 = 8'b0111_1110;

    localparam [7:0] T_Row_0 = 8'b1111_1111;
    localparam [7:0] T_Row_1 = 8'b1111_1111;
    localparam [7:0] T_Row_2 = 8'b0001_1000;
    localparam [7:0] T_Row_3 = 8'b0001_1000;
    localparam [7:0] T_Row_4 = 8'b0001_1000;
    localparam [7:0] T_Row_5 = 8'b0001_1000;
    localparam [7:0] T_Row_6 = 8'b0001_1000;
    localparam [7:0] T_Row_7 = 8'b0001_1000;

    wire in_m = (pix_x >= M_X0) && (pix_x < M_X0 + BOX) &&
                (pix_y >= Y0)   && (pix_y < Y0   + BOX);

    wire in_u = (pix_x >= U_X0) && (pix_x < U_X0 + BOX) &&
                (pix_y >= Y0)   && (pix_y < Y0   + BOX);

    wire in_s = (pix_x >= S_X0) && (pix_x < S_X0 + BOX) &&
                (pix_y >= Y0)   && (pix_y < Y0   + BOX);

    wire in_t = (pix_x >= T_X0) && (pix_x < T_X0 + BOX) &&
                (pix_y >= Y0)   && (pix_y < Y0   + BOX);

    wire [2:0] mx = (pix_x - M_X0) >> 3;
    wire [2:0] my = (pix_y - Y0)   >> 3;
    wire [2:0] ux = (pix_x - U_X0) >> 3;
    wire [2:0] uy = (pix_y - Y0)   >> 3;
    wire [2:0] sx = (pix_x - S_X0) >> 3;
    wire [2:0] sy = (pix_y - Y0)   >> 3;
    wire [2:0] tx = (pix_x - T_X0) >> 3;
    wire [2:0] ty = (pix_y - Y0)   >> 3;

    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            pix_data <= GREEN;
        else if (in_m) begin
            case (my)
                3'd0: pix_data <= M_Row_0[3'd7 - mx] ? WHITE : GREEN;
                3'd1: pix_data <= M_Row_1[3'd7 - mx] ? WHITE : GREEN;
                3'd2: pix_data <= M_Row_2[3'd7 - mx] ? WHITE : GREEN;
                3'd3: pix_data <= M_Row_3[3'd7 - mx] ? WHITE : GREEN;
                3'd4: pix_data <= M_Row_4[3'd7 - mx] ? WHITE : GREEN;
                3'd5: pix_data <= M_Row_5[3'd7 - mx] ? WHITE : GREEN;
                3'd6: pix_data <= M_Row_6[3'd7 - mx] ? WHITE : GREEN;
                3'd7: pix_data <= M_Row_7[3'd7 - mx] ? WHITE : GREEN;
                default: pix_data <= GREEN;
            endcase
        end
        else if (in_u) begin
            case (uy)
                3'd0: pix_data <= U_Row_0[3'd7 - ux] ? WHITE : GREEN;
                3'd1: pix_data <= U_Row_1[3'd7 - ux] ? WHITE : GREEN;
                3'd2: pix_data <= U_Row_2[3'd7 - ux] ? WHITE : GREEN;
                3'd3: pix_data <= U_Row_3[3'd7 - ux] ? WHITE : GREEN;
                3'd4: pix_data <= U_Row_4[3'd7 - ux] ? WHITE : GREEN;
                3'd5: pix_data <= U_Row_5[3'd7 - ux] ? WHITE : GREEN;
                3'd6: pix_data <= U_Row_6[3'd7 - ux] ? WHITE : GREEN;
                3'd7: pix_data <= U_Row_7[3'd7 - ux] ? WHITE : GREEN;
                default: pix_data <= GREEN;
            endcase
        end
        else if (in_s) begin
            case (sy)
                3'd0: pix_data <= S_Row_0[3'd7 - sx] ? WHITE : GREEN;
                3'd1: pix_data <= S_Row_1[3'd7 - sx] ? WHITE : GREEN;
                3'd2: pix_data <= S_Row_2[3'd7 - sx] ? WHITE : GREEN;
                3'd3: pix_data <= S_Row_3[3'd7 - sx] ? WHITE : GREEN;
                3'd4: pix_data <= S_Row_4[3'd7 - sx] ? WHITE : GREEN;
                3'd5: pix_data <= S_Row_5[3'd7 - sx] ? WHITE : GREEN;
                3'd6: pix_data <= S_Row_6[3'd7 - sx] ? WHITE : GREEN;
                3'd7: pix_data <= S_Row_7[3'd7 - sx] ? WHITE : GREEN;
                default: pix_data <= GREEN;
            endcase
        end
        else if (in_t) begin
            case (ty)
                3'd0: pix_data <= T_Row_0[3'd7 - tx] ? WHITE : GREEN;
                3'd1: pix_data <= T_Row_1[3'd7 - tx] ? WHITE : GREEN;
                3'd2: pix_data <= T_Row_2[3'd7 - tx] ? WHITE : GREEN;
                3'd3: pix_data <= T_Row_3[3'd7 - tx] ? WHITE : GREEN;
                3'd4: pix_data <= T_Row_4[3'd7 - tx] ? WHITE : GREEN;
                3'd5: pix_data <= T_Row_5[3'd7 - tx] ? WHITE : GREEN;
                3'd6: pix_data <= T_Row_6[3'd7 - tx] ? WHITE : GREEN;
                3'd7: pix_data <= T_Row_7[3'd7 - tx] ? WHITE : GREEN;
                default: pix_data <= GREEN;
            endcase
        end
        else
            pix_data <= GREEN;
    end

endmodule