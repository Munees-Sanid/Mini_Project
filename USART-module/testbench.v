`include"design.v"
module UART_module_tb();

    reg clk;
    reg rst;
    reg start;
    reg [7:0] data_in;
    
    wire tx;
    wire busy;
    
    UART_module uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
    );

   
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
  
    task send_uart_data(input [7:0] data);
        begin
            @(posedge clk); 
            start = 1;
            data_in = data;
            @(posedge clk);
            start = 0;
            wait (busy == 0); 
        end
    endtask
    
    
    initial begin
        rst = 1;
        start = 0;
        data_in = 8'b0;
        
    
        #20;
        rst = 0;
        
        // Test Case 1: Send a byte of data (e.g., 8'hA5)
        $display("Test Case 1: Sending 0xA5");
        send_uart_data(8'hA5);
        
        // Test Case 2: Send another byte of data (e.g., 8'h3C)
        $display("Test Case 2: Sending 0x3C");
        send_uart_data(8'h3C);
        
        // Test Case 3: Send data during busy state (should wait for completion)
        $display("Test Case 3: Sending 0xFF");
        send_uart_data(8'hFF);
        
     
        #100;
        $display("Simulation Completed");
        $finish;
    end
    
  
    initial begin
        $monitor("Time=%0t | clk=%b | rst=%b | start=%b | data_in=0x%h | tx=%b | busy=%b", 
                 $time, clk, rst, start, data_in, tx, busy);
    end

    initial begin
      $dumpfile("dump.vcd");
      $dumpvars(0);
    end

endmodule
