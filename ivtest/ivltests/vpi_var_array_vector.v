// Check that the words of variable arrays report vpiVector when the
// element is declared with a packed range (even a single-element one) or is
// wider than one bit, and vpiScalar for plain scalar elements.

module test;

  reg           s_reg [1:0];
  logic         s_logic [1:0];
  bit           s_bit [1:0];
  reg [0:0]     v00_reg [1:0];
  logic [0:0]   v00_logic [1:0];
  bit [0:0]     v00_bit [1:0];
  logic [3:3]   v33_logic [1:0];
  logic [3:0]   m4 [3:0];
  reg [0:3]     m4r [1:0];
  bit [7:0]     b8 [1:0];
  bit signed [7:0] b8s [1:0];
  integer       i_arr [1:0];
  int           int_arr [1:0];
  logic [0:0][0:0] p2_arr [1:0];
  reg [0:0]     v_down [1:0];
  reg [0:0]     v_up [0:1];
  integer       idx;
  integer       failed;

  initial begin
    failed = 0;
    idx = 1;
    // Constant word select.
    failed |= $check_sv(s_reg[0], 0, 1);
    failed |= $check_sv(s_logic[1], 0, 1);
    failed |= $check_sv(s_bit[0], 0, 1);
    failed |= $check_sv(v00_reg[0], 1, 1);
    failed |= $check_sv(v00_logic[1], 1, 1);
    failed |= $check_sv(v00_bit[0], 1, 1);
    failed |= $check_sv(v33_logic[0], 1, 1);
    failed |= $check_sv(m4[2], 1, 4);
    failed |= $check_sv(m4r[1], 1, 4);
    failed |= $check_sv(b8[0], 1, 8);
    failed |= $check_sv(b8s[0], 1, 8);
    failed |= $check_sv(i_arr[0], 1, 32);
    failed |= $check_sv(int_arr[1], 1, 32);
    failed |= $check_sv(p2_arr[0], 1, 1);
    // Variable word select.
    failed |= $check_sv(s_reg[idx], 0, 1);
    failed |= $check_sv(v00_reg[idx], 1, 1);
    failed |= $check_sv(m4[idx], 1, 4);
    // Word iteration.
    failed |= $check_sv_words(s_reg, 0, 1);
    failed |= $check_sv_words(s_bit, 0, 1);
    failed |= $check_sv_words(v00_reg, 1, 1);
    failed |= $check_sv_words(v00_bit, 1, 1);
    failed |= $check_sv_words(v33_logic, 1, 1);
    failed |= $check_sv_words(m4, 1, 4);
    failed |= $check_sv_words(b8s, 1, 8);
    failed |= $check_sv_words(int_arr, 1, 32);
    failed |= $check_sv_words(p2_arr, 1, 1);
    failed |= $check_sv_words(v_down, 1, 1);
    failed |= $check_sv_words(v_up, 1, 1);
    if (!failed) $display("PASSED");
  end

endmodule
