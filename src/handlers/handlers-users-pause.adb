-------------------------------------------------------------------------------
--                                                                           --
--                     Copyright (C) 2014-, AdaHeads K/S                     --
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

with GNATCOLL.JSON;

with Response.Templates;

package body Handlers.Users.Pause is
   function Callback return HTTP.Callback is
   begin
      return Pause'Access;
   end Callback;

   function Pause (Request : in Black.Request.Instance)
                  return Black.Response.Class is
      use GNATCOLL.JSON;
      Not_Implemented : constant JSON_Value := Create_Object;
   begin
      Not_Implemented.Set_Field (Response.Status_Text, "Not implemented");

      return Response.Templates.Server_Error
        (Request       => Request,
         Response_Body => Not_Implemented);
   end Pause;
end Handlers.Users.Pause;
