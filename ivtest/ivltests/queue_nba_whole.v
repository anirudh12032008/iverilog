// Check nonblocking assignment of a whole queue or dynamic array.
module main;
  int q[$], oq[$];
  real rq[$], orq[$];
  string sq[$], osq[$];
  int d[], od[];
  int bq[$:2];
  bit failed = 1'b0;

  initial begin
    oq = '{1, 2, 3};
    orq = '{1.5, 2.5};
    osq = '{"a", "b"};
    od = new[2];
    od[0] = 7;
    od[1] = 8;

    q <= oq;
    rq <= orq;
    sq <= osq;
    d <= od;
    bq <= oq;

    // The update must not happen until the NBA region.
    if (q.size() != 0 || rq.size() != 0 || sq.size() != 0 || d.size() != 0) begin
      $display("FAILED: nonblocking assign took effect early");
      failed = 1'b1;
    end

    // The value is captured now, later changes to the source do not leak.
    oq[0] = 99;
    od[0] = 99;
    orq.delete();
    osq.delete();

    #1;
    if (q.size() != 3 || q[0] != 1 || q[2] != 3 ||
        rq.size() != 2 || rq[1] != 2.5 ||
        sq.size() != 2 || sq[1] != "b" ||
        d.size() != 2 || d[0] != 7 || d[1] != 8 ||
        bq.size() != 3 || bq[0] != 1) begin
      $display("FAILED: q=%p d=%p bq=%p", q, d, bq);
      failed = 1'b1;
    end

    // Self assignment and pattern.
    q <= q;
    d <= '{4, 5, 6};
    #1;
    if (q.size() != 3 || q[0] != 1 || d.size() != 3 || d[2] != 6) begin
      $display("FAILED: self/pattern q=%p d=%p", q, d);
      failed = 1'b1;
    end

    // Delayed assignment.
    q <= #2 oq;
    #1;
    if (q[0] != 1) begin
      $display("FAILED: delayed assign took effect early");
      failed = 1'b1;
    end
    #2;
    if (q[0] != 99) begin
      $display("FAILED: delayed assign did not happen, q=%p", q);
      failed = 1'b1;
    end

    if (!failed)
      $display("PASSED");
  end
endmodule
