module named_properties_and_sequences(input bit clk);

  default clocking @(posedge clk);
  endclocking
  

  property some_property(bit a, bit b, bit c, bit d);
    a ##1 b [*2] ##1 c [*3] |-> d;
  endproperty

  
  bit a0, b0, c0, d0;

  on_group0: assert property (
    some_property(a0, b0, c0, d0));


  bit a1, b1, c1, d1;

  on_group1: assert property (
    some_property(a1, b1, c1, d1));
  
endmodule
