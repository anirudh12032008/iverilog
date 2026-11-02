// Check nonblocking assignments to dynamic array and queue elements.
module main;
  int q[$];
  int d[];
  real r[$];
  string s[];
  int bq[$:3];
  bit failed = 1'b0;

  initial begin
    q = '{1, 2, 3};
    d = new[3];
    r = '{1.5, 2.5};
    s = new[2];
    bq = '{1, 2};

    q[2] <= 30;
    d[1] <= 5;
    r[0] <= 9.5;
    s[1] <= "hi";
    bq[2] <= 7;
    q[1] <= #1 20;

    // The update must not happen until the NBA region.
    if (q[2] !== 3 || d[1] !== 0) begin
      $display("FAILED: nonblocking assign took effect early");
      failed = 1'b1;
    end

    #0.5;
    if (q[1] !== 2) begin
      $display("FAILED: delayed assign took effect early");
      failed = 1'b1;
    end

    #1;
    if (q[2] !== 30 || q[1] !== 20 || d[1] !== 5 || r[0] != 9.5 ||
        s[1] != "hi" || bq[2] != 7 || q.size() != 3) begin
      $display("FAILED: q=%p d=%p r=%p s=%p bq=%p", q, d, r, s, bq);
      failed = 1'b1;
    end

    if (!failed)
      $display("PASSED");
  end
endmodule
