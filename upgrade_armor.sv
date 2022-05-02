module upgrade_armor (
    input Reset, frame_clk,
    input [9:0] BallX, BallY, Ball2X, Ball2Y, Ball_Size,
    input [1:0] p1_direction, p2_direction,
    input [9:0] UpgradeX, UpgradeY, Upgrade_Size,
    output [9:0] ArmorX, ArmorY, Armor_Length_Halved, Armor_Height_Halved,
    output was_collected
);

    parameter [9:0] armor_longer_dimension = 12;
    parameter [9:0] armor_shorter_dimension = 12;

    logic [1:0] armor_owner; // One hot: 00 = None, 01 = P1, 10 = P2
    logic [9:0] Armor_Length_Halved_Latched, Armor_Height_Halved_Latched;
    logic [9:0] Armor_X_Latched, Armor_Y_Latched;

    always_ff @ (posedge Reset or posedge frame_clk)
    begin
        if (Reset)
        begin
            Armor_X_Latched <= 10'b0;
            Armor_Y_Latched <= 10'b0;
            armor_owner <= 2'b00;
            was_collected <= 1'b0;
        end
        else
        begin
            if ( (BallX) >= (UpgradeX - Upgrade_Size) &&
                 (BallX) <= (UpgradeX + Upgrade_Size) &&
                 (BallY <= UpgradeY + Upgrade_Size) &&
                 (BallY >= UpgradeY - Upgrade_Size) &&
                 ~was_collected)
            begin
                was_collected <= 1'b1;
                armor_owner <= 2'b01;
            end
            else if ( (Ball2X) >= (UpgradeX - Upgrade_Size) &&
                 (Ball2X) <= (UpgradeX + Upgrade_Size) &&
                 (Ball2Y <= UpgradeY + Upgrade_Size) &&
                 (Ball2Y >= UpgradeY - Upgrade_Size) &&
                 ~was_collected)
            begin
                was_collected <= 1'b1;
                armor_owner <= 2'b10;
            end
            
            // Direction codes: 00 = Facing Left, 01 = Right, 10 = Down, 11 = Up
            // Armor will always attach to the player's rear

            // Attached to P1
            else if (armor_owner[0])
            begin
                case (p1_direction)
                    2'b00:
                    begin
                        Armor_X_Latched <= (BallX + Ball_Size + 10);
                        Armor_Y_Latched <= BallY;
                        Armor_Height_Halved_Latched <= armor_longer_dimension;
                        Armor_Length_Halved_Latched <= armor_shorter_dimension;
                    end
                    2'b01:
                    begin
                        Armor_X_Latched <= (BallX - Ball_Size - 10);
                        Armor_Y_Latched <= BallY;
                        Armor_Height_Halved_Latched <= armor_longer_dimension;
                        Armor_Length_Halved_Latched <= armor_shorter_dimension;
                    end
                    2'b10:
                    begin
                        Armor_X_Latched <= BallX;
                        Armor_Y_Latched <= (BallY - Ball_Size - 10);
                        Armor_Height_Halved_Latched <= armor_shorter_dimension;
                        Armor_Length_Halved_Latched <= armor_longer_dimension;
                    end
                    2'b11:
                    begin
                        Armor_X_Latched <= BallX;
                        Armor_Y_Latched <= (BallY + Ball_Size + 10);
                        Armor_Height_Halved_Latched <= armor_shorter_dimension;
                        Armor_Length_Halved_Latched <= armor_longer_dimension;
                    end
                endcase
            end

            // Attached to P2
            else if (armor_owner[1])
            begin
                case (p2_direction)
                    2'b00:
                    begin
                        Armor_X_Latched <= (Ball2X + Ball_Size + 10);
                        Armor_Y_Latched <= Ball2Y;
                        Armor_Height_Halved_Latched <= armor_longer_dimension;
                        Armor_Length_Halved_Latched <= armor_shorter_dimension;
                    end
                    2'b01:
                    begin
                        Armor_X_Latched <= (Ball2X - Ball_Size - 10);
                        Armor_Y_Latched <= Ball2Y;
                        Armor_Height_Halved_Latched <= armor_longer_dimension;
                        Armor_Length_Halved_Latched <= armor_shorter_dimension;
                    end
                    2'b10:
                    begin
                        Armor_X_Latched <= Ball2X;
                        Armor_Y_Latched <= (Ball2Y - Ball_Size - 10);
                        Armor_Height_Halved_Latched <= armor_shorter_dimension;
                        Armor_Length_Halved_Latched <= armor_longer_dimension;
                    end
                    2'b11:
                    begin
                        Armor_X_Latched <= Ball2X;
                        Armor_Y_Latched <= (Ball2Y + Ball_Size + 10);
                        Armor_Height_Halved_Latched <= armor_shorter_dimension;
                        Armor_Length_Halved_Latched <= armor_longer_dimension;
                    end
                endcase
            end
        end
    end

    assign ArmorX = Armor_X_Latched;
    assign ArmorY = Armor_Y_Latched;
    assign Armor_Height_Halved = Armor_Height_Halved_Latched;
    assign Armor_Length_Halved = Armor_Length_Halved_Latched;

endmodule