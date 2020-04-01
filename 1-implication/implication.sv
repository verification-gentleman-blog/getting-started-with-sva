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
   assert_overlapping_implication: assert property (overlapping_implication);

   // Forces a fail of the implcation property to generate a trace
   assign consequent = 0;


   always @(posedge clk)
     if (antecedent)
       assert (consequent);


   property nonoverlapping_implication;
     antecedent |=> consequent;
   endproperty


   // FIXME Can't get this to cover
   cover_nonoverlapping_implication: cover property (nonoverlapping_implication);

   // TODO Remove once 'cover' generates trace
   assert_nonoverlapping_implication: assert property (nonoverlapping_implication);


  always @(posedge clk)
     if ($past(antecedent))
       assert (consequent);
   
endmodule
