// Check that assigning a queue to or from a class property copies the
// queue. A queue is a value, only the class handle is a reference.

module test;

  typedef int iq_t[$];

  class C;
    int q[$];
    real rq[$];
    string sq[$];
    function iq_t get();
      return q;
    endfunction
  endclass

  class K;
    int q[$];
    function new(int a[$]);
      this.q = a;
    endfunction
  endclass

  class W;
    C c;
    function new();
      c = new;
    endfunction
    function int size();
      C t = c;
      return t.q.size();
    endfunction
    function void grow();
      C t = c;
      t.q.push_back(1);
    endfunction
  endclass

  iq_t sq;
  function iq_t static_func();
    sq.push_back(1);
    return sq;
  endfunction

  bit failed = 1'b0;
  task check(bit ok, string what);
    if (!ok) begin
      $display("FAILED: %s", what);
      failed = 1'b1;
    end
  endtask

  C c, c2;
  K k;
  W w;
  int r[$], r2[$];
  real rr[$], rr2[$];
  string ss[$], ss2[$];

  initial begin
    c = new;
    c2 = new;

    r = '{1, 2, 3};
    c.q = r;
    r.push_back(4);
    check(c.q.size() == 3, "property = variable, change variable");
    c.q.push_back(5);
    check(r.size() == 4, "property = variable, change property");

    r = '{1, 2, 3};
    c.q = r;
    r2 = c.q;
    r2.push_back(4);
    check(c.q.size() == 3, "variable = property, change variable");
    c.q.push_back(5);
    check(r2.size() == 4, "variable = property, change property");

    c.q = '{1, 2};
    c2.q = c.q;
    c2.q.push_back(3);
    check(c.q.size() == 2, "property = property, other object");
    c.q = c.q;
    c.q.push_back(3);
    check(c.q.size() == 3, "property = property, same property");

    c.q = '{1, 2};
    r = c.get();
    r.push_back(3);
    check(c.q.size() == 2, "return of a property");

    r = '{1, 2, 3};
    k = new(r);
    k.q.push_back(4);
    check(r.size() == 3, "constructor stores a copy");

    r = '{1, 2, 3};
    w = new;
    w.c.q = r;
    r.push_back(4);
    check(w.size() == 3, "nested property = variable, change variable");
    w.grow();
    check(r.size() == 4, "nested property = variable, change property");

    r = '{1, 2, 3, 4};
    c.q = r[1:2];
    c.q.push_back(5);
    check(r.size() == 4 && c.q.size() == 3, "property = slice");

    sq.delete();
    c.q = static_func();
    r = static_func();
    check(c.q.size() == 1, "property = static function result");

    c.q = '{1, 2, 3};
    c.q.push_back(4);
    check(c.q.size() == 4, "property = assignment pattern");

    rr = '{1.5, 2.5};
    c.rq = rr;
    rr.push_back(3.5);
    rr2 = c.rq;
    rr2.push_back(4.5);
    rr2 = c.rq;
    check(rr2.size() == 2, "real queue");

    ss = '{"a", "b"};
    c.sq = ss;
    ss.push_back("c");
    ss2 = c.sq;
    ss2.push_back("d");
    ss2 = c.sq;
    check(ss2.size() == 2, "string queue");

    if (failed)
      $display("FAILED");
    else
      $display("PASSED");
  end

endmodule
