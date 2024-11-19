module shifter(in,shift,sout);
  //declarations of inputs and output
  input [15:0] in; // The 16-bit input that is to be shifted
  input [1:0] shift; //The 2-bit contol signal for the shift operation
  output reg [15:0] sout; //The 16-bit shifted output


  //Shifter logic which is based on the value of the shift contol signal
  always_comb begin
    case (shift)
      2'b00: sout = in; //no shifting
      2'b01: sout = in << 1; //shift left by 1 bit
      2'b10: sout = in >> 1; //shift right by 1 bit
      2'b11: sout = {in[15], in[15:1]}; //arithmetic shift right by 1 bit while retaining the MSB
      // same as sout = in >> 1; in[15] = in[14];
      default: sout = 16'b0000000000000000;
    endcase
  end    
endmodule      
