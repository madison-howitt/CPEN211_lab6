module datapath_tb(); 
  // declare inputs to top-level module
  reg [15:0] datapath_in; 
  reg [2:0] writenum, readnum;
  reg [1:0] shift, ALUop; 
  reg vsel, write, clk, loada, loadb, asel, bsel, loads, loadc, err;

  // declare outputs of top-level module 
  wire [15:0] datapath_out; 
  wire Z_out;

  datapath dut(
    // inputs 
    .datapath_in(datapath_in), 
    .vsel(vsel), 
    .writenum(writenum), 
    .write(write), 
    .readnum(readnum), 
    .clk(clk), 
    .loada(loada), 
    .loadb(loadb), 
    .shift(shift), 
    .asel(asel), 
    .bsel(bsel), 
    .ALUop(ALUop), 
    .loads(loads), 
    .loadc(loadc), 
    // outputs 
    .Z_out(Z_out), 
    .datapath_out(datapath_out));

  initial begin   // forever looping clock 
        forever begin
            clk = 1'b0; #5; 
            clk = 1'b1; #5; 
        end
    end 

  initial begin 
    err = 0; 
    // TEST with video example
    
    datapath_in = 16'b0000000000101010;   // input 42
    vsel = 1; 
    write = 1; 
    writenum = 3'b011;   // write to register R3
    #10;                 // wait one clock cycle
    write = 0;           // reset write to avoid unintended writes

    datapath_in = 16'b0000000000001101;   // input 13
    vsel = 1; 
    write = 1; 
    writenum = 3'b101;   // write to register R5
    #10;                 // wait one clock cycle
    write = 0;           // reset write to avoid unintended writes

    vsel = 0;

    // load 42 from R3 to register B 
    readnum = 3'b011; 
    loadb = 1;
    #10;                // wait one clock cycle 
    loadb = 0;          // reset loadb

    // check that the value was read correctly from the register
    if (dut.data_out !== 16'b0000000000101010) begin 
      $display("ERROR: data_out is %b, expected 16'b0000000000101010", dut.data_out);
      err = 1;
    end

    readnum = 3'b101;   // load 13 from R5 to register A
    loada = 1; 
    #10;                // wait one clock cycle 
    loada = 0; 

    // check that the value was read correctly from the register 
    if (dut.data_out !== 16'b0000000000001101) begin 
      $display("ERROR: data_out is %b, expected 16'b0000000000001101", dut.data_out);
      err = 1;
    end

    // set ALU to add 42 + 13
    shift = 2'b0;   // no shift
    asel = 0;       // copies the value of A
    bsel = 0;       // copies the value of B
    ALUop = 2'b0;   // adding so ALUop = 2'b00
    loadc = 1;      // puting output of ALU into datapath_out so loadc is true 
    loads = 0; 
    #10;            // wait one clock cycle
    loadc = 0;      // reset loadc

    // print output of top level module, should be the sum of 13 and 42 (= 55)
    if (dut.datapath_out !== 16'b0000000000110111) begin 
      $display("ERROR: datapath_out is %b, expected 16'b0000000000110111", dut.datapath_out);
      err = 1;
    end

    if (err == 0)
      $display("Passed all tests!"); 

    $stop; 
  end 
endmodule: datapath_tb
    
    

  
