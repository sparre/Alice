-------------------------------------------------------------------------------
--                                                                           --
--                                  Alice                                    --
--                                                                           --
--                                 Contact                                   --
--                                                                           --
--                                  BODY                                     --
--                                                                           --
--                     Copyright (C) 2012-, AdaHeads K/S                     --
--                                                                           --
--  This is free software;  you can redistribute it and/or modify it         --
--  under terms of the  GNU General Public License  as published by the      --
--  Free Software  Foundation;  either version 3,  or (at your  option) any  --
--  later version. This library is distributed in the hope that it will be   --
--  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of  --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     --
--  You should have received a copy of the GNU General Public License and    --
--  a copy of the GCC Runtime Library Exception along with this program;     --
--  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
--  <http://www.gnu.org/licenses/>.                                          --
--                                                                           --
-------------------------------------------------------------------------------

with Database;
with GNATCOLL.JSON;
with Yolk.Utilities;

package body Contact is

   ----------------
   --  Callback  --
   ----------------

   function Callback
     return AWS.Dispatchers.Callback.Handler
   is
   begin
      return AWS.Dispatchers.Callback.Create (JSON_Response.Generate'Access);
   end Callback;

   -------------------
   --  Create_JSON  --
   -------------------

   procedure Create_JSON
     (C     : in out Cursor;
      Value : in out Common.JSON_String)
   is
      use Common;
      use GNATCOLL.JSON;
      use Yolk.Utilities;

      DB_Columns : JSON_Value;
      J          : JSON_Value := Create_Object;
   begin
      if C.Has_Row then
         DB_Columns := Create_Object;

         J := GNATCOLL.JSON.Read (To_String (C.Element.JSON),
                                  "contact_json.error");

         DB_Columns.Set_Field (TS (C.Element.Ce_Id_Column_Name),
                               C.Element.Ce_Id);

         DB_Columns.Set_Field (TS (C.Element.Ce_Name_Column_Name),
                               C.Element.Ce_Name);

         DB_Columns.Set_Field (TS (C.Element.Is_Human_Column_Name),
                               C.Element.Is_Human);

         if C.Element.Is_Human then
            J.Set_Field ("type", "human");
         else
            J.Set_Field ("type", "function");
         end if;

         J.Set_Field ("db_columns", DB_Columns);
      end if;

      Value := To_JSON_String (J.Write);
   end Create_JSON;

   ---------------
   --  Element  --
   ---------------

   function Element
     (C : in Cursor)
      return Row
   is
      use Common;
      use Yolk.Utilities;
   begin
      return Row'(JSON                 => To_JSON_String (C.Value (0)),
                  Ce_Id                => C.Integer_Value (1, Default => 0),
                  Ce_Id_Column_Name    => TUS (C.Field_Name (1)),
                  Ce_Name              => TUS (C.Field_Name (2)),
                  Ce_Name_Column_Name  => TUS (C.Value (2)),
                  Is_Human             => C.Boolean_Value (3),
                  Is_Human_Column_Name => TUS (C.Field_Name (3)));
   end Element;

   ----------------------
   --  Prepared_Query  --
   ----------------------

   function Prepared_Query
     return GNATCOLL.SQL.Exec.Prepared_Statement
   is
      package DB renames Database;

      use GNATCOLL.SQL;
      use GNATCOLL.SQL.Exec;

      Get_Contact : constant SQL_Query
        := SQL_Select (Fields =>
                         DB.Contactentity.Json &    --  0
                         DB.Contactentity.Ce_Id &   --  1
                         DB.Contactentity.Ce_Name & --  2
                         DB.Contactentity.Is_Human, --  3
                       Where  =>
                         DB.Contactentity.Ce_Id = Integer_Param (1));

      Prepared_Get_Contact : constant Prepared_Statement
        := Prepare (Query         => Get_Contact,
                    Auto_Complete => True,
                    On_Server     => True,
                    Name          => "get_contact");
   begin
      return Prepared_Get_Contact;
   end Prepared_Query;

   ------------------------
   --  Query_Parameters  --
   ------------------------

   function Query_Parameters
     (Request : in AWS.Status.Data)
      return GNATCOLL.SQL.Exec.SQL_Parameters
   is
      use GNATCOLL.SQL.Exec;
   begin
      return (1 => +Natural'Value (Response.Get_Ce_Id_Key (Request)));
   end Query_Parameters;

end Contact;