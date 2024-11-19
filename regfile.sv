module regfile(data_in,writenum,write,readnum,clk,data_out);
  // declarations from Lab 5 outline
  input [15:0] data_in;
  input [2:0] writenum, readnum;
  input write, clk;
  output reg [15:0] data_out;

  wire [7:0] write_out, read_out;               // initialize 8-bit buses for decoded values of writenum and readnum
  reg [15:0] R0, R1, R2, R3, R4, R5, R6, R7;    // initialize 16-bit registers 

  decode38 decode_write(writenum, write_out);   // decode writenum in binary to write_out in one-hot
  decode38 decode_read(readnum, read_out);      // decode readnum in binary to read_out in one-hot 

  always_comb begin 
    data_out = 16'b0;
    case (read_out) // one register value R0-R7 is copied to data_out depending on readnum (decoded to read_out)
      8'b00000001: data_out = R0; 
      8'b00000010: data_out = R1;  
      8'b00000100: data_out = R2; 
      8'b00001000: data_out = R3; 
      8'b00010000: data_out = R4; 
      8'b00100000: data_out = R5; 
      8'b01000000: data_out = R6; 
      default: data_out = R7; 
    endcase 
  end

  always_ff @(posedge clk) begin 
    if (write) begin   // if write is high, data_in is copied to registers R0-R7 depending on writenum (decoded to write_out)
      case (write_out) 
        8'b00000001: R0 <= data_in; 
        8'b00000010: R1 <= data_in; 
        8'b00000100: R2 <= data_in; 
        8'b00001000: R3 <= data_in; 
        8'b00010000: R4 <= data_in;
        8'b00100000: R5 <= data_in; 
        8'b01000000: R6 <= data_in;
        default: R7 <= data_in; 
      endcase
    end 
  end
  
endmodule

module decode38(input [2:0] a, output reg [7:0] b);
    always_comb begin
        b = 8'b00000000;  // Default value to prevent latch inference
        b = 1 << a;       // Shift operation
    end
endmodule
