// Check that a shallow copy of a class object (new obj) copies queue and
// dynamic array properties, while a class handle property still refers to
// the same object.

module test;

  class Inner;
    int n;
  endclass

  class C;
    int q[$];
    int d[];
    real rq[$];
    string sq[$];
    string sd[];
    Inner h;
  endclass

  bit failed = 1'b0;
  task check(bit ok, string what);
    if (!ok) begin
      $display("FAILED: %s", what);
      failed = 1'b1;
    end
  endtask

  C c, c2;
  Inner h;
  real rr2[$];
  string s[], ss2[$];

  initial begin
    c = new;
    c.q = '{1, 2};
    c.d = '{1, 2, 3};
    s = new[2];
    c.sd = s;
    c.h = new;

    c2 = new c;
    c2.q.push_back(3);
    check(c.q.size() == 2, "queue, change copy");
    c.q.push_back(3);
    check(c2.q.size() == 3, "queue, change original");

    c2.d.reverse();
    check(c.d[0] == 1, "darray, change copy");
    c.d.reverse();
    check(c2.d[0] == 3, "darray, change original");

    c2.sd.delete();
    check(c.sd.size() == 2, "string darray");

    c.rq.push_back(1.5);
    c2 = new c;
    c2.rq.push_back(2.5);
    rr2 = c.rq;
    check(rr2.size() == 1, "real queue");
    c2.sq.push_back("x");
    ss2 = c.sq;
    check(ss2.size() == 0, "string queue");

    c.h.n = 5;
    c2 = new c;
    h = c2.h;
    h.n = 7;
    h = c.h;
    check(h.n == 7, "class handle stays shared");

    if (failed)
      $display("FAILED");
    else
      $display("PASSED");
  end

endmodule
