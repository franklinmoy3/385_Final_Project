module tank_barrel (
    input Reset, frame_clk,
    input [9:0] BallX, BallY, Ball_Size,
    input [1:0] p_direction,
    output logic [9:0] BarrelX, BarrelY, Barrel_Length_Halved, Barrel_Height_Halved
);

    parameter [9:0] Barrel_longer_dimension = 6;
    parameter [9:0] Barrel_shorter_dimension = 4;

    logic [9:0] Barrel_Length_Halved_Latched, Barrel_Height_Halved_Latched;
    logic [9:0] Barrel_X_Latched, Barrel_Y_Latched;

    // Direction codes: 00 = Facing Left, 01 = Right, 10 = Down, 11 = Up
    // Barrel will always attach to the player's front

    always_ff @ (posedge Reset or posedge frame_clk)
    begin
        case (p_direction)
            2'b00:
            begin
                Barrel_X_Latched <= (BallX - Ball_Size - 3);
                Barrel_Y_Latched <= BallY;
                Barrel_Height_Halved_Latched <= Barrel_longer_dimension;
                Barrel_Length_Halved_Latched <= Barrel_shorter_dimension;
            end
            2'b01:
            begin
                Barrel_X_Latched <= (BallX + Ball_Size + 3);
                Barrel_Y_Latched <= BallY;
                Barrel_Height_Halved_Latched <= Barrel_longer_dimension;
                Barrel_Length_Halved_Latched <= Barrel_shorter_dimension;
            end
            2'b10:
            begin
                Barrel_X_Latched <= BallX;
                Barrel_Y_Latched <= (BallY + Ball_Size + 3);
                Barrel_Height_Halved_Latched <= Barrel_shorter_dimension;
                Barrel_Length_Halved_Latched <= Barrel_longer_dimension;
            end
            2'b11:
            begin
                Barrel_X_Latched <= BallX;
                Barrel_Y_Latched <= (BallY - Ball_Size - 3);
                Barrel_Height_Halved_Latched <= Barrel_shorter_dimension;
                Barrel_Length_Halved_Latched <= Barrel_longer_dimension;
            end
        endcase
    end

    assign BarrelX = Barrel_X_Latched;
    assign BarrelY = Barrel_Y_Latched;
    assign Barrel_Height_Halved = Barrel_Height_Halved_Latched;
    assign Barrel_Length_Halved = Barrel_Length_Halved_Latched;

endmodule