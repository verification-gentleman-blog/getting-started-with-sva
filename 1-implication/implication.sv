module implication(input bit clk);

   bit antecedent;
   bit consequent;

   
   default clocking @(posedge clk);
   endclocking


   property overlapping_implication;
     antecedent |-> consequent;
   endproperty


   // FIXME Can't get this to cover
   cover_overlapping_implication: cover property (overlapping_implication);

   // TODO Remove once 'cover' generates trace
   // Forces a fail of the implcation property to generate a trace
   assign consequent = 0;
   assert_overlapping_implication: assert property (overlapping_implication);


   always @(posedge clk)
     if (antecedent)
       assert (consequent);
   
endmodule
