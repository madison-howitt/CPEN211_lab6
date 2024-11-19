module ALU(Ain,Bin,ALUop,out,Z,N,O);
  // declarations from Lab 5 outline
  input [15:0] Ain, Bin;
  input [1:0] ALUop;
  output reg [15:0] out;
  output reg Z, N, O; // zero, negative, and overflow flags

  always_comb begin 
    case (ALUop) 
      2'b00: {
        out = Ain + Bin; 
        O = ((Ain[15] == Bin[15]) && (out[15] != Ain[15])) ? 1 : 0;
      } // ^^^ THIS LINE MIGHT BE WRONG, SHOULD CHECK IN CONTEXT
      2'b01: {
        out = Ain + (~Bin + 1'b1);
        O = ((Ain[15] == Bin[15]) && (out[15] != Ain[15])) ? 1 : 0;
      }
      2'b10: {
        out = Ain & Bin;
        O = 0; 
      } // overflow not possible for bitwise AND or bitwise NOT
      default: {
        out = ~Bin; 
        O = 0;
      }
    endcase 
    Z = (out == 16'b0) ? 1 : 0;
    N = (out[15] == 1) ? 1 : 0;
  end 
  
endmodule
