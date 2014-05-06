with
  Ahven.Framework;

package CFC_Tests.Reception_Contact_IDs is
   type Test is new Ahven.Framework.Test_Case with null record;

   overriding
   procedure Initialize (T : in out Test);
private
   procedure Value_Of_Image_Of;
   procedure Value_Fails;
   procedure Image_Of_Value_Of;
end CFC_Tests.Reception_Contact_IDs;
