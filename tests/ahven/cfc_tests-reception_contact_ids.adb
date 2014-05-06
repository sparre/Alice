with
  Ada.Strings.Unbounded;
with
  Model;

package body CFC_Tests.Reception_Contact_IDs is
   function "+" (Item : in String)
                return Ada.Strings.Unbounded.Unbounded_String
     renames Ada.Strings.Unbounded.To_Unbounded_String;
   function "+" (Item : in Ada.Strings.Unbounded.Unbounded_String)
                return String
     renames Ada.Strings.Unbounded.To_String;

   type String_Array is array (Positive range <>)
     of Ada.Strings.Unbounded.Unbounded_String;
   type ID_Array is array (Positive range <>)
     of Model.Reception_Contact_Identifier;

   procedure Image_Of_Value_Of is
      Examples : constant String_Array := (+"0@0",
                                           +"0@1",
                                           +"0@2",
                                           +"0@10",
                                           +"1@0",
                                           +"1@1",
                                           +"1@2",
                                           +"1@10",
                                           +"10@0",
                                           +"10@1",
                                           +"10@2",
                                           +"10@10");
   begin
      for Index in Examples'Range loop
         declare
            use Model;
            Intermediate : Reception_Contact_Identifier;
         begin
            Intermediate := Value (+Examples (Index));

            Ahven.Assert
              (Condition => Image (Intermediate) = +Examples (Index),
               Message   => +Examples (Index));
         exception
            when others =>
               Ahven.Fail (Message => "Exception while processing '" &
                                      (+Examples (Index)) & "'");
         end;
      end loop;
   end Image_Of_Value_Of;

   overriding
   procedure Initialize (T : in out Test) is
      use Ahven.Framework;
   begin
      T.Set_Name ("Contact@Reception IDs");

      pragma Style_Checks ("M100"); --  Readable table

      Add_Test_Routine (T,  Value_Of_Image_Of'Access, "Value (Image (*))");
      Add_Test_Routine (T,  Image_Of_Value_Of'Access, "Image (Value (*))");

      pragma Style_Checks ("M79"); --  Standard line length
   end Initialize;

   procedure Value_Fails is
      Examples : constant String_Array := (+"@",
                                           +"1@",
                                           +"@1",
                                           +"@1@1",
                                           +"10@",
                                           +"@10",
                                           +"@10@1",
                                           +"@1@10",
                                           +"@10@10");
   begin
      for Index in Examples'Range loop
         declare
            use Model;
            Intermediate : Reception_Contact_Identifier;
            pragma Unreferenced (Intermediate);
         begin
            Intermediate := Value (+Examples (Index));

            Ahven.Fail (Message => "'" & (+Examples (Index)) & "' is not a " &
                                   "valid reception contact ID");
         exception
            when Constraint_Error =>
               null; --  Expected result.
            when others =>
               Ahven.Fail (Message => "Exception while processing '" &
                                      (+Examples (Index)) & "'");
         end;
      end loop;
   end Value_Fails;

   procedure Value_Of_Image_Of is
      Examples : constant ID_Array := ((Contact_ID =>  0, Reception_ID =>  0),
                                       (Contact_ID =>  0, Reception_ID =>  1),
                                       (Contact_ID =>  0, Reception_ID =>  2),
                                       (Contact_ID =>  0, Reception_ID => 10),
                                       (Contact_ID =>  1, Reception_ID =>  0),
                                       (Contact_ID =>  1, Reception_ID =>  1),
                                       (Contact_ID =>  1, Reception_ID =>  2),
                                       (Contact_ID =>  1, Reception_ID => 10),
                                       (Contact_ID =>  2, Reception_ID =>  0),
                                       (Contact_ID =>  2, Reception_ID =>  1),
                                       (Contact_ID =>  2, Reception_ID =>  2),
                                       (Contact_ID =>  2, Reception_ID => 10),
                                       (Contact_ID => 10, Reception_ID =>  0),
                                       (Contact_ID => 10, Reception_ID =>  1),
                                       (Contact_ID => 10, Reception_ID =>  2),
                                       (Contact_ID => 10, Reception_ID => 10));
   begin
      for Index in Examples'Range loop
         declare
            use Model;
            Intermediate : constant String := Image (Examples (Index));
         begin
            Ahven.Assert (Condition => Value (Intermediate) = Examples (Index),
                          Message   => "Example" & Positive'Image (Index));
         exception
            when others =>
               Ahven.Fail (Message => "Example" & Positive'Image (Index));
         end;
      end loop;
   end Value_Of_Image_Of;

end CFC_Tests.Reception_Contact_IDs;
