with
  CFC_Tests.Reception_Contact_IDs;

package body CFC_Tests is
   function Suite return Ahven.Framework.Test_Suite is
      use Ahven.Framework;
      Reception_Contact_ID_Test : CFC_Tests.Reception_Contact_IDs.Test;
   begin
      return Suite : Test_Suite := Create_Suite ("Call-Flow-Control") do
         Add_Static_Test (Suite, Reception_Contact_ID_Test);
      end return;
   end Suite;
end CFC_Tests;
