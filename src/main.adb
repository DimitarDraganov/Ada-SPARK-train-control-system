with Train; use Train;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   procedure TrainStats is
   begin
      Put_Line("==============================");
      Put_Line("Train status is: " & ReactorClass.ReactorState'Image);
      Put_Line("Train speed is: " & TrainState'Image);
      Put_Line("Carriage Number: " & CarriagesClass.NumberOfCarriages'Image);
      Put_Line("Encumbrance Status: " & CarriagesClass.EncumbranceStatus'Image);

      Put_Line("---");

      Put_Line("Water level: " & ReactorClass.WaterLevel'Image);

      Put_Line("---");

      Put_Line("Rod number is: " & ReactorClass.InsertedRods'Image);
      Put_Line("Temp number is: " & ReactorClass.ReactorTemperature'Image);
      Put_Line("Reactor state is: " & ReactorClass.ReactorState'Image);
      Put_Line("---");


      Put_Line("Electricy Generated is: " & ReactorClass.ElectricityGenerated'Image);
      Put_Line("==============================");

   end TrainStats;


   procedure ControlLayout is
   begin
      Put_Line("==============================");

      Put_Line("Control scheme for the Train procedure");
      Put_Line(" ");
      Put_Line("Enter '1' in order to Add a Rod");
      Put_Line("Enter '2' in order to Remove a Rod");
      Put_Line("Enter '3' in order to Attach a Carriage");
      Put_Line("Enter '4' in order to Detatch a Carriage");
      Put_Line("Enter '5' in order to Stop the Train");
      Put_Line("Enter '6' in order to Start the Train");
      Put_Line("Enter '7' in order to Stop the Engine(maintanace procesure)");
      Put_Line("Enter '8' in order to Start the Engine");
      Put_Line("Enter '9' in order to show all current value of the train");
      Put_Line(" ");
      Put_Line("Enter 'g' to start the simulation");
      Put_Line("Enter 's' to stop the simulation");
      Put_Line(" ");
      Put_Line("Giving any other input will stop the system");

      Put_Line("==============================");

   end ControlLayout;

   Str : String (1..2);
   Last : Natural;


   task ManualCommands;
   task TrainCheck;
   task ReactorIncrement;

task body TrainCheck is
   begin
      WaterLevelCheck;

   loop
         ReactorHeatLimitCheck;
         ReactorStatusCheck;
         CarriageCheck;
         SpeedCheck;
         if TrainState = OverTheSpeedLimit then Put_Line("The train has gone over the speed limit"); end if;
         if ReactorClass.ReactorState = Overheated then Put_Line("Reactor has Overheated"); end if;
         delay 0.1;
   end loop;

end TrainCheck;


   procedure AddRodProcedure is
   begin
      AddRod;
      delay 0.1;
      Put_Line("------------------------------");
      Put_Line("Reactor State: " & ReactorClass.ReactorState'Image);
      Put_Line("");
      Put_Line("Inserted Rods: " & ReactorClass.InsertedRods'Image);
      Put_Line("Reactor Temperature: " & ReactorClass.ReactorTemperature'Image);
      Put_Line("Electricity Generated: " & ReactorClass.ElectricityGenerated'Image);

      Put_Line("------------------------------");
      Put_Line("");

   end AddRodProcedure;


   procedure RemoveRodProcedure is
   begin
      RemoveRod;
      delay 0.1;
      Put_Line("------------------------------");
      Put_Line("Reactor State: " & ReactorClass.ReactorState'Image);
      Put_Line("");
      Put_Line("Inserted Rods: " & ReactorClass.InsertedRods'Image);
      Put_Line("Reactor Temperature: " & ReactorClass.ReactorTemperature'Image);
      Put_Line("Electricity Generated: " & ReactorClass.ElectricityGenerated'Image);

      Put_Line("------------------------------");
      Put_Line("");

   end RemoveRodProcedure;


   procedure AttachCarriageProcedure is
   begin
      AttachCarriage;
      delay 0.1;
      Put_Line("------------------------------");

      Put_Line("Train Speed: " & TrainState'Image);
      Put_Line("Carriages Number: " & CarriagesClass.NumberOfCarriages'Image);

      Put_Line("Encumbrance Status: " & CarriagesClass.EncumbranceStatus'Image);

      Put_Line("------------------------------");
      Put_Line("");

   end AttachCarriageProcedure;


   procedure DetachCarriageProcedure is
   begin
      DetachCarriage;
      delay 0.1;
      Put_Line("------------------------------");

      Put_Line("Train Speed: " & TrainState'Image);

      Put_Line("Carriages Number: " & CarriagesClass.NumberOfCarriages'Image);

      Put_Line("Encumbrance Status: " & CarriagesClass.EncumbranceStatus'Image);

      Put_Line("------------------------------");
      Put_Line("");

   end DetachCarriageProcedure;


   procedure StopTrainProcedure is
   begin
      StopTrain;
      delay 0.6;
      Put_Line("------------------------------");

      Put_Line("Train State: " & TrainState'Image);

      Put_Line("------------------------------");
      Put_Line("");

   end StopTrainProcedure;


   procedure StartTrainProcedure is
   begin
      StartTrain;
      delay 0.1;
      Put_Line("------------------------------");

      Put_Line("Train State: " & TrainState'Image);

      Put_Line("------------------------------");
      Put_Line("");

   end StartTrainProcedure;


   procedure StopEngineProcedure is
   begin
      StopEngine;
      delay 0.1;
      Put_Line("------------------------------");

      Put_Line("Reactor State: " & ReactorClass.ReactorState'Image);

      Put_Line("------------------------------");
      Put_Line("");

   end StopEngineProcedure;


   procedure StartEngineProcedure is
   begin
      StartEngine;
      delay 0.1;
      Put_Line("------------------------------");

      Put_Line("Reactor State: " & ReactorClass.ReactorState'Image);

      Put_Line("------------------------------");
      Put_Line("");

   end StartEngineProcedure;


   task body ManualCommands is
   begin
      Put_Line("Press '0' in order to view the Control Layout");
      loop
         Put_Line("Enter manual command");
         Get_Line(Str,Last);
         case Str(1) is
         when '1' => AddRodProcedure;
         when '2' => RemoveRodProcedure;
         when '3' => AttachCarriageProcedure;
         when '4' => DetachCarriageProcedure;
         when '5' => StopTrainProcedure;
         when '6' => StartTrainProcedure;
         when '7' => StopEngineProcedure;
         when '8' => StartEngineProcedure;
         when '9' => TrainStats;
         when '0' => ControlLayout;
         when 'g' => StartIncrement;
         when 's' => StopIncrement;
      when others => abort TrainCheck; abort ReactorIncrement; exit;
      end case;
   end loop;
   delay 0.2;
end ManualCommands;


   task body ReactorIncrement is
   begin
      loop
         if (IsIncrement = Yes) then
            TemepratureIncrement;
            Put_Line("Reactor Temperature: " & ReactorClass.ReactorTemperature'Image);
         end if;

         delay 2.0;
      end loop;
   end ReactorIncrement;


begin
   null;
end Main;
