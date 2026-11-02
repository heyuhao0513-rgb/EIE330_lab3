`timescale 1ns/1ns
module tb_vga_must;

    reg  sys_clk;
    reg  sys_rst_n;
    wire hsync;
    wire vsync;
    wire [15:0] rgb;

    time t_h1, t_h2, t_h3;
    time t_v1, t_v2, t_v3;

    vga_must u_top(
        .sys_clk   (sys_clk),
        .sys_rst_n (sys_rst_n),
        .hsync     (hsync),
        .vsync     (vsync),
        .rgb       (rgb)
    );

    initial begin
        sys_clk = 1'b0;
        forever #10 sys_clk = ~sys_clk;
    end

    initial begin
        $dumpfile("vga_must.vcd");
        $dumpvars(0, tb_vga_must);
    end

    task check_pixel;
        input [9:0]  x;
        input [9:0]  y;
        input [15:0] exp;
        begin
            wait((u_top.u_ctrl.cnt_v == (10'd35 + y)) &&
                 (u_top.u_ctrl.cnt_h == (10'd144 + x)) &&
                 (u_top.u_ctrl.rgb_valid == 1'b1));
            #1;
            if (rgb !== exp)
                $display("ERROR pixel x=%0d y=%0d rgb=%h exp=%h at %0t",
                         x, y, rgb, exp, $time);
            else
                $display("OK    pixel x=%0d y=%0d rgb=%h", x, y, rgb);
        end
    endtask

    initial begin
        sys_rst_n = 1'b0;
        #1000;

        if (rgb !== 16'h0000)
            $display("ERROR: reset rgb is not black: %h", rgb);
        else
            $display("OK: reset rgb is black");

        sys_rst_n = 1'b1;

        @(negedge hsync); t_h1 = $time;
        @(posedge hsync); t_h2 = $time;
        @(negedge hsync); t_h3 = $time;
        $display("HSync pulse = %0t ns, period = %0t ns",
                 t_h2 - t_h1, t_h3 - t_h1);

        @(negedge vsync); t_v1 = $time;
        @(posedge vsync); t_v2 = $time;
        @(negedge vsync); t_v3 = $time;
        $display("VSync pulse = %0t ns, period = %0t ns",
                 t_v2 - t_v1, t_v3 - t_v1);


        check_pixel(10'd0,   10'd0,   16'h07E0);
        check_pixel(10'd144, 10'd208, 16'hFFFF);
        check_pixel(10'd184, 10'd208, 16'h07E0);
        check_pixel(10'd240, 10'd208, 16'hFFFF);
        check_pixel(10'd344, 10'd208, 16'hFFFF);
        check_pixel(10'd432, 10'd208, 16'hFFFF);
        #1000;
        $finish;
    end

endmodule