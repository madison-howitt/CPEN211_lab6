module cpu(clk,reset,s,load,in,out,N,V,Z,w);
  input clk, reset, s, load;
  input [15:0] in;
  output reg [15:0] out;
  output reg Z, N, V, w; // zero, negative and overflow flags // w = 1 if currently in reset state, "wait" 
                                                              // w = 0 otherwise 

  `define S0 4'b0000
  `define S1 4'b0001
  `define S2 4'b0010
  `define S3 4'b0011
  `define S4 4'b0100
  `define S5 4'b0101
  `define S6 4'b0110
  `define S7 4'b0111
  `define S8 4'b1000
  `define S9 4'b1001
  

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
                w <= 1; // Waiting for load and start signals
                if (load) irout <= in;
                if (s) begin
                    state <= `S1; // Transition to Decode state
                    w <= 0;       // Exit wait state
                end
            end
            `S1: begin // Decode instruction
                case (opcode)
                    3'b110: begin
                        if (op == 2'b10) state <= `S2; // MOV immediate
                        else if (op == 2'b00) state <= `S3; // MOV shifted register
                    end
                    3'b101: begin
                        case (ALUop)
                            2'b00: state <= `S4; // ADD
                            2'b01: state <= `S5; // CMP
                            2'b10: state <= `S6; // AND
                            2'b11: state <= `S7; // MVN
                        endcase
                    end
                    default: state <= `S0; // Undefined opcode
                endcase
            end
            `S2: begin // MOV immediate
                vsel <= 1; // Select immediate value
                write <= 1; // Enable writing to register
                nsel <= 3'b010; // Select destination register
                state <= `S0; // Return to Wait
            end
            `S3: begin // MOV shifted register
                asel <= 1; // Select A input as 0
                bsel <= 0; // Use shifted value of Rm
                write <= 1; // Enable write-back
                nsel <= 3'b010; // Select Rd
                state <= `S0; // Return to Wait
            end
            `S4: begin // ADD
                loada <= 1; // Load Rn into A
                nsel <= 3'b100; // Select Rn
                state <= `S8; // Proceed to GetB
            end
            `S8: begin // GetB state for ADD
                loadb <= 1; // Load shifted Rm into B
                nsel <= 3'b001; // Select Rm
                state <= `S9; // Proceed to Execute
            end
            `S9: begin // Execute ADD
                loadc <= 1; // Compute result in ALU
                write <= 1; // Write back to Rd
                nsel <= 3'b010; // Select Rd
                state <= `S0; // Return to Wait
            end
            `S5: begin // CMP
                loada <= 1; // Load Rn into A
                nsel <= 3'b100; // Select Rn
                state <= `S10; // Proceed to compare
            end
            `S10: begin // Execute CMP
                loadb <= 1; // Load shifted Rm into B
                loads <= 1; // Update status flags
                state <= `S0; // Return to Wait
            end
            `S6: begin // AND
                loada <= 1; // Load Rn into A
                nsel <= 3'b100; // Select Rn
                state <= `S8; // Proceed to GetB
            end
            `S7: begin // MVN
                loadb <= 1; // Load shifted Rm into B
                loadc <= 1; // Compute result in ALU
                write <= 1; // Write back to Rd
                nsel <= 3'b010; // Select Rd
                state <= `S0; // Return to Wait
            end
        endcase
    end
end

          
            
      
      
   

      
