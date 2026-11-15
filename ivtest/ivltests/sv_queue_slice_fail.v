// A queue slice can only be used where a queue is expected.

module top;
  int q[$] = '{1, 2, 3};
  int x;

  initial begin
    x = q[0:1];
    $display("FAILED");
  end
endmodule
