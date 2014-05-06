with
  Ahven.Framework,
  Ahven.Text_Runner;

procedure CFC_Tests.Run is
   Suite : Ahven.Framework.Test_Suite := CFC_Tests.Suite;
begin
   Ahven.Text_Runner.Run (Suite);
end CFC_Tests.Run;
