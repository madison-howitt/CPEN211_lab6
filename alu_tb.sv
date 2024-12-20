module ALU_tb();
  // declarations from Lab 5 outline
  reg [15:0] Ain, Bin;
  reg [1:0] ALUop;
  reg [15:0] out;
  reg Z, err;

  ALU dut(.Ain(Ain), .Bin(Bin), .ALUop(ALUop), .out(out), .Z(Z));

  initial begin
    err = 0; 

    // TEST CASE #1: check for Ain = 6, Bin = 4
    
    Ain = 16'b0000000000000110;  
    Bin = 16'b0000000000000100; 

    ALUop = 2'b00;   // Test for '+'
    #5

    if (out !== 16'b0000000000001010) begin
      $display("ERROR: out is %b, expected 16'b0000000000001010", dut.out);
      err = 1;
    end 
    if (Z !== 0) begin
      $display("ERROR: out is %b, expected 0", dut.Z);
      err = 1;
    end 
    #5

    ALUop = 2'b01;   // Test for '-'
    #5

    if (out !== 16'b0000000000000010) begin
      $display("ERROR: out is %b, expected 16'b0000000000000010", dut.out);
      err = 1;
    end 
    if (Z !== 0) begin
      $display("ERROR: out is %b, expected 0", dut.Z);
      err = 1;
    end 

    ALUop = 2'b10;   // Test for bitwise '&'
    #5

    if (out !== 16'b0000000000000100) begin
      $display("ERROR: out is %b, expected 16'b0000000000000100", dut.out);
      err = 1;
    end 
    if (Z !== 0) begin
      $display("ERROR: out is %b, expected 0", dut.Z);
      err = 1;
    end 

    ALUop = 2'b11;   // Test for bitwise '~'
    #5

    if (out !== 16'b1111111111111011) begin
      $display("ERROR: out is %b, expected 16'b1111111111111011", dut.out);
      err = 1;
    end 
    if (Z !== 0) begin
      $display("ERROR: out is %b, expected 0", dut.Z);
      err = 1;
    end
    
    // PASSED
    
    
    // TEST CASE #2: check for Ain = 8, Bin = 8
    
    Ain = 16'b0000000000001000;  
    Bin = 16'b0000000000001000;   
    
    ALUop = 2'b00;   // Test for '+'
    #5

    if (out !== 16'b0000000000010000) begin
      $display("ERROR: out is %b, expected 16'b0000000000010000", dut.out);
      err = 1;
    end 
    if (Z !== 0) begin
      $display("ERROR: out is %b, expected 0", dut.Z);
      err = 1;
    end

    ALUop = 2'b01;   // Test for '-'
    #5

    if (out !== 16'b0000000000000000) begin
      $display("ERROR: out is %b, expected 16'b0000000000000000", dut.out);
      err = 1;
    end 
    if (Z !== 1) begin
      $display("ERROR: out is %b, expected 1", dut.Z);
      err = 1;
    end 

    ALUop = 2'b10;   // Test for bitwise '&'
    #5

    if (out !== 16'b0000000000001000) begin
      $display("ERROR: out is %b, expected 16'b0000000000001000", dut.out);
      err = 1;
    end 
    if (Z !== 0) begin
      $display("ERROR: out is %b, expected 0", dut.Z);
      err = 1;
    end 
    
    ALUop = 2'b11;   // Test for bitwise '~'
    #5

    if (out !== 16'b1111111111110111) begin
      $display("ERROR: out is %b, expected 16'b1111111111110111", dut.out);
      err = 1;
    end 
    if (Z !== 0) begin
      $display("ERROR: out is %b, expected 0", dut.Z);
      err = 1;
    end 

    // PASSED


    // TEST CASE #3: check for Ain = 5, Bin = -5
    
    Ain = 16'b0000000000000101;  
    Bin = 16'b1111111111111011;   
    
    ALUop = 2'b00;   // Test for '+'
    #5

    if (out !== 16'b0000000000000000) begin
      $display("ERROR: out is %b, expected 16'b0000000000000000", dut.out);
      err = 1;
    end 
    if (Z !== 1) begin
      $display("ERROR: out is %b, expected 1", dut.Z);
      err = 1;
    end 

    ALUop = 2'b01;   // Test for '-'
    #5

    if (out !== 16'b0000000000001010) begin
      $display("ERROR: out is %b, expected 16'b0000000000001010", dut.out);
      err = 1;
    end 
    if (Z !== 0) begin
      $display("ERROR: out is %b, expected 0", dut.Z);
      err = 1;
    end 

    ALUop = 2'b10;   // Test for bitwise '&'
    #5

    if (out !== 16'b0000000000000001) begin
      $display("ERROR: out is %b, expected 16'b0000000000000001", dut.out);
      err = 1;
    end 
    if (Z !== 0) begin
      $display("ERROR: out is %b, expected 0", dut.Z);
      err = 1;
    end 

    ALUop = 2'b11;   // Test for bitwise '~'
    #5

    if (out !== 16'b0000000000000100) begin
      $display("ERROR: out is %b, expected 16'b0000000000000100", dut.out);
      err = 1;
    end 
    if (Z !== 0) begin
      $display("ERROR: out is %b, expected 0", dut.Z);
      err = 1;
    end

    // PASSED 

    if (err == 0) 
      $display("Passed all tests!"); 

    $stop;
  end 
endmodule: ALU_tb
