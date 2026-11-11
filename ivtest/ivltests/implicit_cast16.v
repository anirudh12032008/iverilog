// Check that nonblocking assignments convert only two-state concatenation components.

module test;

  bit failed = 1'b0;

  `define check(val, exp) \
    if (val !== exp) begin \
      $display("FAILED(%0d). '%s' expected %b, got %b", `__LINE__, \
               `"val`", exp, val); \
      failed = 1'b1; \
    end

  logic [3:0] four;
  bit [3:0] two;

  initial begin
    {two, four} <= 8'bx1z0_z01x;
    #1;
    `check({two, four}, 8'b0100_z01x);

    if (!failed) begin
      $display("PASSED");
    end
  end

endmodule
