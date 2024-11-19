module datapath(datapath_in, mdata, sximm8, PC, C, sximm5, vsel, writenum, write, readnum, clk, loada, loadb, shift, asel, bsel, ALUop, loads, loadc, status, datapath_out);
  // declare inputs to top-level module
  input [15:0] datapath_in, mdata, sximm8, C, sximm5; // new variables for lab 6: mdata, sximm8, PC, C, sximm5
  input [7:0] PC; 
  input [2:0] writenum, readnum;
  input [1:0] shift, ALUop, vsel; // changed vsel to 2-bit select input
  input write, clk, loada, loadb, asel, bsel, loads, loadc;  

  // declare outputs of top-level module 
  output reg [15:0] datapath_out; 
  output reg [2:0] status; // formerly Z_out 

  // declare intermidate registers 
  reg [15:0] data_in, data_out, aout, in, sout, Ain, Bin, out;
  reg Z, N, V; // added negative and overflow flags for Lab 6

  // instantiate regfile
  regfile reg_block(.data_in(data_in), .writenum(writenum), .write(write), 
                      .readnum(readnum), .clk(clk), .data_out(data_out));
  // instantiate shifter
  shifter shift_block(.in(in), .shift(shift), .sout(sout));
  // instantiate ALU 
  ALU alu_block(.Ain(Ain), .Bin(Bin), .ALUop(ALUop), .out(out), .Z(Z), .N(N), .V(V)); 
  
  always_comb begin 
    // assign 0 for Lab 6
    mdata = 16'b0;
    PC = 8'b0; 
    // change mux to 4-input (vsel changed to 2-bit value)
    data_in = vsel[0] ? {vsel[1] ? C : {8'b0, PC}} : {vsel[1] ? sximm8 : mdata};   
    // if vsel[0] is true
          // if vsel[1] is true (vsel = 2'b11), C is copied to data_in
          // if vsel[1] is false (vsel = 2'b10), {8'b0, PC} is copied to data_in
    // if vsel[0] is false: 
          // if vsel [1] is true (vsel = 2'b01), sximm8 is copied to data_in 
          // if vesel [1] is fasle (vsel = 2'b00), mdata is copied to data_in
    
    // copy values to Ain and Bin based on asel and bsel respectively 
    Ain = asel ? 16'b0 : aout;
    Bin = bsel ? sximm5 : sout; 
  end

  always_ff @(posedge clk) begin 
    // each load enabled register is updated on posedge clk
    if (loada)   // if loada is selected, the value of data_out is copied to aout
      aout <= data_out; 
    if (loadb)   // if loadb is selected, the value of data_out is copied to in  
      in <= data_out; 
    if (loadc)   // if loadc is selected, the value of out is copied to datapath_out
      datapath_out <= out; 
    if (loads) {  // if loads is selected, the values of Z, N, and O are copied to bits 2, 1, and 0 of status respectively
      status[2] <= Z; 
      status[1] <= N;
      status[0] <= V;
    }
  end 
  
endmodule 
// :)))))))
