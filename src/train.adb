package body Train with SPARK_mode
is

   --Rod Procedures--
   procedure AddRod is
   begin
      if (ReactorClass.InsertedRods < 5 and ReactorClass.ElectricityGenerated >= 200 and ReactorClass.ReactorTemperature >=60) then
         ReactorClass.InsertedRods := ReactorClass.InsertedRods + 1;

         ReactorClass.ReactorTemperature := ReactorClass.ReactorTemperature - 60;

         ReactorClass.ElectricityGenerated := ReactorClass.ElectricityGenerated - 200;

      end if;
   end AddRod;


   procedure RemoveRod is
   begin
      if (ReactorClass.InsertedRods > 1 and ReactorClass.ReactorTemperature < ReactorHeatLimit and ReactorClass.ElectricityGenerated <= 800) then
         ReactorClass.InsertedRods := ReactorClass.InsertedRods - 1;

         ReactorClass.ReactorTemperature := ReactorClass.ReactorTemperature + 60;

         ReactorClass.ElectricityGenerated := ReactorClass.ElectricityGenerated + 200;

      end if;
   end RemoveRod;


   --Carriage Procedures--
   procedure AttachCarriage is
   begin
      if (TrainState = Stoped and CarriagesClass.NumberOfCarriages < Carriages'Last) then

         CarriagesClass.NumberOfCarriages := CarriagesClass.NumberOfCarriages + 1;

      end if;

   end AttachCarriage;


   procedure DetachCarriage is
   begin
      if (TrainState = Stoped and CarriagesClass.NumberOfCarriages > MinimumCarriageNumber) then

         CarriagesClass.NumberOfCarriages := CarriagesClass.NumberOfCarriages - 1;

      end if;

   end DetachCarriage;


   --Movement Controls--
   procedure StopTrain is
   begin
      if (TrainState /= Stoped) then

         TrainState := Stoped;

      end if;

   end StopTrain;


   procedure StartTrain is
   begin
      if (TrainState = Stoped) then

         TrainState := Standby;

      end if;

   end StartTrain;


   procedure StopEngine is
   begin

      if (TrainState = Stoped) then

         ReactorClass.ReactorState := Off;

      end if;

   end StopEngine;


   procedure StartEngine is
   begin

      if (ReactorClass.ReactorState = Off) then

         ReactorClass.ReactorState := On;

      end if;

   end StartEngine;


   --System Check Procedures--
   procedure ReactorHeatLimitCheck is
   begin
      if (ReactorClass.ReactorTemperature >= ReactorHeatLimit and ReactorClass.ReactorState /= Off) then
         ReactorClass.ReactorState := Overheated;
         TrainState := Stoped;

      end if;

   end ReactorHeatLimitCheck;


   procedure ReactorStatusCheck is
   begin
      if (ReactorClass.ReactorTemperature < ReactorHeatLimit and ReactorClass.ReactorState /= Off) then
         ReactorClass.ReactorState := On;
      end if;

   end ReactorStatusCheck;


   procedure WaterLevelCheck is
   begin
      if (ReactorClass.WaterLevel = Sufficient and ReactorClass.ReactorTemperature >= 60) then
         ReactorClass.ReactorTemperature := ReactorClass.ReactorTemperature - 60;
      else

         if (ReactorClass.ReactorTemperature <= 240) then
            ReactorClass.ReactorTemperature := ReactorClass.ReactorTemperature + 60;
         end if;

      end if;

   end WaterLevelCheck;


   procedure CarriageCheck is
   begin
      if (CarriagesClass.NumberOfCarriages >= MinimumCarriageNumber and CarriagesClass.NumberOfCarriages <= Carriages'Last) then

         if (CarriagesClass.NumberOfCarriages >= 6) then
            CarriagesClass.EncumbranceStatus := Yes;
         else
            CarriagesClass.EncumbranceStatus := No;
         end if;

      end if;

   end CarriageCheck;


   procedure SpeedCheck is
   begin
      if (ReactorClass.ElectricityGenerated >= Electricity'First and ReactorClass.ElectricityGenerated <= Electricity'Last and TrainState /= Stoped) then

         if (CarriagesClass.EncumbranceStatus = Yes) then

            if (ReactorClass.ElectricityGenerated < 500) then
               TrainState := Slow;
            end if;

            if (ReactorClass.ElectricityGenerated >= 500 and ReactorClass.ElectricityGenerated < 800) then
               TrainState := Average;
            end if;

            if (ReactorClass.ElectricityGenerated >= 800) then
               TrainState := Fast;
            end if;
         end if;


         If (CarriagesClass.EncumbranceStatus = No) then

            if (ReactorClass.ElectricityGenerated < 200 ) then
               TrainState := Slow;
            end if;

            if (ReactorClass.ElectricityGenerated >= 200 and ReactorClass.ElectricityGenerated < 400) then
               TrainState := Average;
            end if;

            if (ReactorClass.ElectricityGenerated >= 400 and ReactorClass.ElectricityGenerated < 900) then
               TrainState := Fast;
            end if;

            if (ReactorClass.ElectricityGenerated >= 900) then
               TrainState := OverTheSpeedLimit;
            end if;
         end if;

      end if;

   end SpeedCheck;


   --Temperature Increment--
   procedure TemepratureIncrement is
   begin
      if (ReactorClass.ReactorTemperature <= Temperature'Last and ReactorClass.ReactorTemperature <= 270) then

         ReactorClass.ReactorTemperature := ReactorClass.ReactorTemperature + 30;

      end if;

   end TemepratureIncrement;


   procedure StartIncrement is
   begin
      if (IsIncrement = No) then
         IsIncrement := Yes;
      end if;

   end StartIncrement;


   procedure StopIncrement is
   begin
      if (IsIncrement = Yes) then
         IsIncrement := No;
      end if;

   end StopIncrement;


end Train;
