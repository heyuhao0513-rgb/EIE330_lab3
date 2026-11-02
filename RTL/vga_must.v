`timescale 1ns/1ns
module vga_must(
    input  wire        sys_clk,
    input  wire        sys_rst_n,
    output wire        hsync,
    output wire        vsync,
    output wire [15:0] rgb
);

    wire        vga_clk;
    wire [9:0]  pix_x;
    wire [9:0]  pix_y;
    wire [15:0] pix_data;

    pll u_pll(
        .sys_clk   (sys_clk),
        .sys_rst_n (sys_rst_n),
        .vga_clk   (vga_clk)
    );

    vga_ctrl u_ctrl(
        .vga_clk   (vga_clk),
        .sys_rst_n (sys_rst_n),
        .pix_data  (pix_data),
        .pix_x     (pix_x),
        .pix_y     (pix_y),
        .hsync     (hsync),
        .vsync     (vsync),
        .rgb       (rgb)
    );

    vga_pic u_pic(
        .vga_clk   (vga_clk),
        .sys_rst_n (sys_rst_n),
        .pix_x     (pix_x),
        .pix_y     (pix_y),
        .pix_data  (pix_data)
    );

endmodule