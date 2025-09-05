`timescale 1ns/1ps
module tb_i2c_master_write;
  reg clk, reset;
  wire i2c_sda, i2c_scl;
  
  i2c_master_write uut(
    .clk(clk),
    .reset(reset),
    .i2c_scl(i2c_scl),
    .i2c_sda(i2c_sda));
    
  initial begin
    $dumpfile ("dump.vcd");
    $dumpvars (0, tb_i2c_master_write);
  end
    
  initial begin
    $dumpfile ("dump.vcd");
    $dumpvars (0, tb_i2c_master_write);
    $dumpvars (1, uut);
  end
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    reset = 1; #20 reset = 0; #220;
    #5 $finish;
  end
endmodule
    
