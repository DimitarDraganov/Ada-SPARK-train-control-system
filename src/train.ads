package Train with SPARK_mode
is

   type ReactorCore is (On, Off, Overheated);
   type Temperature is range 0..300;
   type Electricity is range 0..1000;
   type NumberOfRods is range 1..5;
   type Water is (Insufficient, Sufficient);

   ReactorHeatLimit : constant Temperature := 240;

   --reactor record
   type TrainReactor is record
      ReactorState: ReactorCore;
      ReactorTemperature: Temperature;
      ElectricityGenerated: Electricity;
      InsertedRods: NumberOfRods;
      WaterLevel: Water;
   end record;


   type Encumbrance is (Yes,No);
   type Carriages is range 0..8;

   MinimumCarriageNumber : constant Carriages := 2;

   --carriage record
   type TrainCarriages is record
      EncumbranceStatus: Encumbrance;
      NumberOfCarriages: Carriages;
   end record;


   type Speed is (Stoped, Standby, Slow, Average, Fast, OverTheSpeedLimit);

   type IncrementHeat is (Yes,No);


   --values are set
   ReactorClass : TrainReactor := (ReactorState => (On), ReactorTemperature => (120), ElectricityGenerated => (600), InsertedRods => (2), WaterLevel => (Insufficient));
   CarriagesClass : TrainCarriages := (EncumbranceStatus => (No), NumberOfCarriages => (4));
   TrainState: Speed := Average;
   IsIncrement: IncrementHeat := No;


   --Rod Procedures--
   procedure AddRod with
     Global =>(In_Out => ReactorClass),
     Pre => ReactorClass.InsertedRods < 5 and ReactorClass.ReactorTemperature >= 60 and ReactorClass.ElectricityGenerated >= 200,
     Post => ReactorClass.InsertedRods <= NumberOfRods'Last and ReactorClass.ReactorTemperature >= Temperature'First and ReactorClass.ElectricityGenerated >= Electricity'First;


   procedure RemoveRod with
     Global =>(In_Out => ReactorClass),
     Pre => ReactorClass.InsertedRods > 1 and ReactorClass.ReactorTemperature < ReactorHeatLimit and ReactorClass.ElectricityGenerated <= 800,
     Post => ReactorClass.InsertedRods >= NumberOfRods'First and ReactorClass.ReactorTemperature <= Temperature'Last and ReactorClass.ElectricityGenerated <= Electricity'Last;


   --Carriage Procedures--
   procedure AttachCarriage with
     Global =>(In_Out => CarriagesClass, Input => TrainState),
     Pre => TrainState = Stoped and CarriagesClass.NumberOfCarriages < Carriages'Last,
     Post => TrainState = Stoped and CarriagesClass.NumberOfCarriages <= Carriages'Last;


   procedure DetachCarriage with
     Global =>(In_Out => CarriagesClass, Input => TrainState),
     Pre => TrainState = Stoped and CarriagesClass.NumberOfCarriages > MinimumCarriageNumber,
     Post => TrainState = Stoped and CarriagesClass.NumberOfCarriages >= MinimumCarriageNumber;


   --Movement Controls--
   procedure StopTrain with
     Global =>(In_Out => TrainState),
     Pre => TrainState /= Stoped,
     Post => TrainState = Stoped;


   procedure StartTrain with
     Global =>(In_Out => TrainState),
     Pre => TrainState = Stoped,
     Post => TrainState = Standby;


   procedure StopEngine with
     Global =>(In_Out => ReactorClass, Input => TrainState),
     Pre => TrainState = Stoped,
     Post => ReactorClass.ReactorState = Off;


   procedure StartEngine with
     Global =>(In_Out => ReactorClass),
     Pre => ReactorClass.ReactorState = Off,
     Post => ReactorClass.ReactorState = On;


   --System Check Procedures--
   procedure ReactorHeatLimitCheck with
     Global =>(In_Out => (ReactorClass, TrainState)),
     Pre => ReactorClass.ReactorTemperature >= ReactorHeatLimit and ReactorClass.ReactorState /= Off,
     Post => ReactorClass.ReactorState = Overheated and TrainState = Stoped;


   procedure ReactorStatusCheck with
     Global =>(In_Out => ReactorClass),
     Pre => ReactorClass.ReactorTemperature < ReactorHeatLimit and ReactorClass.ReactorState /= Off,
     Post => ReactorClass.ReactorState = On;


   procedure WaterLevelCheck with
     Global =>(In_Out => ReactorClass),
     Pre => ReactorClass.WaterLevel = Sufficient and ReactorClass.ReactorTemperature >= 60 and ReactorClass.ReactorTemperature <= 240,
     Post => ReactorClass.ReactorTemperature <= Temperature'Last and ReactorClass.ReactorTemperature >= Temperature'First;


    procedure CarriageCheck with
     Global =>(In_Out => CarriagesClass),
     Pre => CarriagesClass.NumberOfCarriages >= MinimumCarriageNumber and CarriagesClass.NumberOfCarriages <= Carriages'Last,
     Post => CarriagesClass.EncumbranceStatus = Yes or CarriagesClass.EncumbranceStatus = No,
     Contract_Cases => (CarriagesClass.NumberOfCarriages >= 6 => CarriagesClass.EncumbranceStatus = Yes,
                        CarriagesClass.NumberOfCarriages < 6 => CarriagesClass.EncumbranceStatus = No);


   procedure SpeedCheck with
     Global =>(In_Out => TrainState, Input => (ReactorClass, CarriagesClass)),
     Pre => ReactorClass.ElectricityGenerated >= Electricity'First and ReactorClass.ElectricityGenerated <= Electricity'Last and TrainState /= Stoped,
     Post => TrainState = Standby or TrainState = Slow or TrainState = Average or TrainState = Fast or TrainState = OverTheSpeedLimit,
     Contract_Cases => (CarriagesClass.EncumbranceStatus = Yes and ReactorClass.ElectricityGenerated < 500 => TrainState = Slow,
                        CarriagesClass.EncumbranceStatus = Yes and ReactorClass.ElectricityGenerated >= 500 and ReactorClass.ElectricityGenerated < 800 => TrainState = Average,
                        CarriagesClass.EncumbranceStatus = Yes and ReactorClass.ElectricityGenerated >= 800 => TrainState = Fast,
                        CarriagesClass.EncumbranceStatus = No and ReactorClass.ElectricityGenerated < 200 => TrainState = Slow,
                        CarriagesClass.EncumbranceStatus = No and ReactorClass.ElectricityGenerated >= 200 and ReactorClass.ElectricityGenerated < 400 => TrainState = Average,
                        CarriagesClass.EncumbranceStatus = No and ReactorClass.ElectricityGenerated >= 400 and ReactorClass.ElectricityGenerated < 900 => TrainState = Fast,
                        CarriagesClass.EncumbranceStatus = No and ReactorClass.ElectricityGenerated >= 900 => TrainState = OverTheSpeedLimit);


   --Temperature Increment--
   procedure TemepratureIncrement with
     Global => (In_Out => ReactorClass),
     Pre => ReactorClass.ReactorTemperature <= Temperature'Last and ReactorClass.ReactorTemperature <= 270,
     Post => ReactorClass.ReactorTemperature <= Temperature'Last;


   procedure StartIncrement with
     Global => (In_Out => IsIncrement),
     Pre => IsIncrement = No,
     Post => IsIncrement = Yes;


   procedure StopIncrement with
     Global => (In_Out => IsIncrement),
     Pre => IsIncrement = Yes,
     Post => IsIncrement = No;


end Train;
