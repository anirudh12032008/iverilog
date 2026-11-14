// Check that objects declared with a packed range report vpiVector even
// when the range has a single element, and that plain scalars stay scalar.

module sub(input s_in, input [0:0] v_in, output s_out, output [0:0] v_out);
  assign s_out = s_in;
  assign v_out = v_in;
endmodule

module test;

  reg       s_reg;
  logic     s_logic;
  wire      s_wire = 1'b0;
  bit       s_bit;
  reg [0:0] v00_reg;
  logic [0:0] v00_logic;
  bit [0:0] v00_bit;
  logic [3:3] v33_logic;
  reg [0:3] v03_reg;
  reg [3:0] v30_reg;
  wire [0:0] v00_wire = 1'b0;
  wire [3:3] v33_wire = 1'b0;
  wire [3:0] v30_wire = 4'b0;
  logic [0:0][0:0] v_packed2;
  wire      s_arr [1:0];
  wire [0:0] v_arr [1:0];
  assign s_arr[0] = 1'b0;
  assign v_arr[0] = 1'b0;

  sub dut(.s_in(s_wire), .v_in(v00_wire), .s_out(), .v_out());

  integer failed;

  initial begin
    failed = 0;
    s_reg = 0; s_logic = 0; s_bit = 0; v00_reg = 0; v00_logic = 0;
    v00_bit = 0; v33_logic = 0; v03_reg = 0; v30_reg = 0; v_packed2 = 0;
    failed |= $check_sv("test.s_reg", 0, 1);
    failed |= $check_sv("test.s_logic", 0, 1);
    failed |= $check_sv("test.s_wire", 0, 1);
    failed |= $check_sv("test.s_bit", 0, 1);
    failed |= $check_sv("test.v00_reg", 1, 1);
    failed |= $check_sv("test.v00_logic", 1, 1);
    failed |= $check_sv("test.v00_bit", 1, 1);
    failed |= $check_sv("test.v33_logic", 1, 1);
    failed |= $check_sv("test.v03_reg", 1, 4);
    failed |= $check_sv("test.v30_reg", 1, 4);
    failed |= $check_sv("test.v00_wire", 1, 1);
    failed |= $check_sv("test.v33_wire", 1, 1);
    failed |= $check_sv("test.v30_wire", 1, 4);
    failed |= $check_sv("test.v_packed2", 1, 1);
    failed |= $check_sv("test.dut.s_in", 0, 1);
    failed |= $check_sv("test.dut.v_in", 1, 1);
    failed |= $check_sv("test.dut.s_out", 0, 1);
    failed |= $check_sv("test.dut.v_out", 1, 1);
    failed |= $check_sv("test.s_arr[0]", 0, 1);
    failed |= $check_sv("test.v_arr[0]", 1, 1);
    if (!failed) $display("PASSED");
  end

endmodule
