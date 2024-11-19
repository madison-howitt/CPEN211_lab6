module ALU(Ain,Bin,ALUop,out,Z);
  // declarations from Lab 5 outline
  input [15:0] Ain, Bin;
  input [1:0] ALUop;
  output reg [15:0] out;
  output reg Z;

  always_comb begin 
    case (ALUop) 
      2'b00: out = Ain + Bin; 
      2'b01: out = Ain + (~Bin + 1'b1); 
      2'b10: out = Ain & Bin; 
      default: out = ~Bin; 
    endcase 
    Z = (out == 16'b0) ? 1 : 0;
  end 
  
endmodule
