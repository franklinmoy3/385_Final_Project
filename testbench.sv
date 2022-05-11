module testbench();

timeunit 10ns;    // Half clock cycle at 50 MHz
            // This is the amount of time represented by #1 
timeprecision 1ns;


logic Reset_h, Clk;
logic [9:0] ballxsig, ballysig, ballsizesig;
logic [9:0] bulletxsig, bulletysig, bulletsizesig;
logic [9:0] BarrierX, BarrierY, Barrier_Height_Halved, Barrier_Length_Halved;
logic bullet_1_collision;
logic [3:0] player_1_collision;

barrier b(.Reset(Reset_h), .frame_clk(Clk), .BallX(ballxsig), .BallY(ballysig), .Ball_Size(ballsizesig), .BulletX(bulletxsig), .BulletY(bulletysig), .Bullet_Size(bulletsizesig), .BarrierX, .BarrierY, .Barrier_Height_Halved, .Barrier_Length_Halved, .player_1_collision, .bullet_1_collision);

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 


initial begin: TEST_VECTORS

Reset_h = 0;
BarrierX = 240;
BarrierY = 240;
Barrier_Height_Halved = 12;
Barrier_Length_Halved = 12;

ballxsig = 160;
ballysig = 80;
ballsizesig = 4;

bulletxsig = ballxsig;
bulletysig = ballysig;
bulletsizesig = 2;

// Bullet 1 hits barrier
#10 bulletxsig = BarrierX;
bulletysig = BarrierY;

// P1 hits left
#10 bulletxsig = 120;
bulletysig = 120;
#10 ballxsig = BarrierX - Barrier_Length_Halved - 3;
ballysig = BarrierY;

// P1 hits right
#10 ballxsig = 160;
#10 ballxsig = BarrierX + Barrier_Length_Halved + 3;

// P1 hits top
#10 ballxsig = 160;
ballysig = 80;
#10 ballxsig = BarrierX;
ballysig = BarrierY - Barrier_Height_Halved - 3 - ballsizesig;

// P1 hits bottom
#10 ballysig = 80;
#10 ballysig = BarrierY + Barrier_Height_Halved + 3 + ballsizesig;


end
endmodule