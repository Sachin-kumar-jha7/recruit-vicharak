`timescale 1ns/1ps
module i2c_master_write (
  input clk, 
  input reset,
  output i2c_scl,
  output reg i2c_sda);
  
  reg [7:0] state, count, data;
  reg [6:0] addr;
  reg i2c_scl_enable = 0;
  
  assign i2c_scl = (i2c_scl_enable == 0) ? 1 : ~clk;
  
  always @(negedge clk) begin
    if (reset == 1) begin
      i2c_scl_enable <= 0;
    end else begin
      if ((state == 0) || (state == 1) || (state == 6)) begin
        i2c_scl_enable <= 0; 
      end else begin 
        i2c_scl_enable <=1; 
      end
    end
  end
  
  always @(posedge clk) begin
    if (reset == 1) begin
      state <= 0;
      i2c_sda <= 1;
      addr <= 7'h50;
      count <= 8'd0;
      data <= 8'haa;
    end
    
    else begin
      case (state)
        0: begin                 // idle state
          i2c_sda <=1;
          state <= 1;
        end
        
        1: begin                    // start state
          i2c_sda <= 0;
          state <= 2;
          count <= 6;
        end
        
        2: begin                            // addr state
          i2c_sda <= addr[count];
          if (count == 0) state <= 3;
          else count <= count - 1;
        end
        
        3: begin                             // RW
          i2c_sda <= 1;
          state <= 4;
        end
        
        4: begin                             // wack
          state <= 5;
          count <= 7;
        end
        
        5: begin                            //data
          i2c_sda <= data[count];
          if (count == 0) state <= 7;
          else count <= count - 1;
        end
        
        7: state <= 6;                      // wack2
        6: begin                            // stop
          i2c_sda <= 1;
          state <=0;
        end
      endcase
    end
  end
endmodule
