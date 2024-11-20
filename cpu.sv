module cpu(clk,reset,s,load,in,out,N,V,Z,w);
  input clk, reset, s, load;
  input [15:0] in;
  output reg [15:0] out;
  output reg Z, N, V, w; // zero, negative and overflow flags // w = 1 if currently in reset state, "wait" 
                                                              // w = 0 otherwise 

  `define S0 3'b000
  `define S1 3'b001
  `define S2 3'b010
  `define S3 3'b011
  `define S4 3'b100

  instruction_decoder instruct_block(.irout(irout), .nsel(nsel), .opcode(opcode), .op(op), .ALUop(ALUop), .sximm5(sximm5), 
                              .sximm8(sximm8), .shift(shift), .readnum(readnum), .writenum(writenum));
  // declare intermidate registers 
  reg [15:0] irout;

  
  always_ff (@posedge clk) begin 
    if (load) 
      irout <= in; 
......

  end 
endmodule 



module instruction_decoder (irout, nsel, opcode, op, ALUop, sximm5, sximm8, shift, readnum, writenum);
  input [15:0] irout; 
  input [2:0] nsel; 
  output reg [15:0] sximm5, sximm8; 
  output reg [2:0] opcode, readnum, writenum; 
  output reg [1:0] op, ALUop, shift; 

  always_comb begin
    // outputs to FSM 
    opcode = irout[15:13]; 
    op = irout[12:11];

    // outputs to datapath
    ALUop = irout[12:11]; 
    shift = irout[4:3]; 

    // readnum and writenum outputs to datapath
    case (nsel) // nsel is 3-bit one-hot
      3'b001: begin // Rd
        readnum = irout[7:5];
        writenum = irout[7:5];
      end
      3'b010: begin // Rm
        readnum = irout[2:0];
        writenum = irout[2:0];
      end
      3'b100: begin // Rn
        readnum = irout[10:8];
        writenum = irout[10:8];
      end
      default: begin
        readnum = 3'bxxx;
        writenum = 3'bxxx;
      end
    endcase

    // sign extentions to imm5 and imm8 inputs
    sximm8 = {{8{irout[7]}}, irout[7:0]}; // imm8
    sximm5 = {{11{irout[4]}}, irout[4:0]}; // imm5
      
  end 
endmodule



module FSM (clk, reset, s, load, nsel, loada, loadb, asel, bsel, loadc, vsel, write, w); 
  input clk, reset, s, load;
  output reg [2:0] nsel; 
  output reg loada, loadb, asel, bsel, vsel, write, w; 

  reg [2:0] state; 

  always_ff (@posedge clk) begin
    if (reset or (state == `S0 and ~s)) begin //reset configuration if the reset is 1 on posedge clk
      w <= 1;  
      state <= `S0; 
    end 
    else begin
      case (state) 
        `S0: begin
          loada = 1; 
          
      
      
    end 
  end 
endmodule 

  
