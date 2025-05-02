`timescale 1ns/1ps
`include"design.v"
module async_fifo_tb;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    reg wr_clk, rd_clk;
    reg wr_rst, rd_rst;
    reg wr_en, rd_en;
    reg [DATA_WIDTH-1:0] wr_data;
    wire [DATA_WIDTH-1:0] rd_data;
    wire full, empty;

    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .wr_clk(wr_clk),
        .wr_rst(wr_rst),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .full(full),
        .rd_clk(rd_clk),
        .rd_rst(rd_rst),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .empty(empty)
    );

    initial begin
        wr_clk = 0;
        rd_clk = 0;
        forever #5 wr_clk = ~wr_clk;
    end

    initial begin
        forever #7 rd_clk = ~rd_clk;
    end

    initial begin
        wr_rst = 1;
        rd_rst = 1;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;

        #20;
        wr_rst = 0;
        rd_rst = 0;

        #10;

        // Write data into FIFO
        repeat (10) begin
            @(posedge wr_clk);
            if (!full) begin
                wr_en = 1;
                wr_data = wr_data + 1;
            end else begin
                wr_en = 0;
            end
        end
        wr_en = 0;

        #50;

        // Read data from FIFO
        repeat (10) begin
            @(posedge rd_clk);
            if (!empty) begin
                rd_en = 1;
            end else begin
                rd_en = 0;
            end
        end
        rd_en = 0;

        #100;
        $finish;
    end

initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars(0, async_fifo_tb);  
end

endmodule

