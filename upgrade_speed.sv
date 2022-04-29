module upgrade_speed (
    input Reset, frame_clk,
    input [9:0] BallX, BallY, Ball2X, Ball2Y, Ball_Size,
    input [9:0] UpgradeX, UpgradeY, Upgrade_Size,
    output speed_1_upgraded, speed_2_upgraded, was_collected
);

    logic speed_1_upgraded_latched, speed_2_upgraded_latched;

    always_ff @ (posedge Reset or posedge frame_clk)
    begin
        if (Reset)
        begin
            speed_1_upgraded_latched <= 1'b0;
            speed_2_upgraded_latched <= 1'b0;
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
                speed_1_upgraded_latched <= 1'b1;
                speed_2_upgraded_latched <= 1'b0;
                was_collected <= 1'b1;
            end
            else if ( (Ball2X) >= (UpgradeX - Upgrade_Size) &&
                 (Ball2X) <= (UpgradeX + Upgrade_Size) &&
                 (Ball2Y <= UpgradeY + Upgrade_Size) &&
                 (Ball2Y >= UpgradeY - Upgrade_Size) &&
                 ~was_collected)
            begin
                speed_1_upgraded_latched <= 1'b0;
                speed_2_upgraded_latched <= 1'b1;
                was_collected <= 1'b1;
            end

        end
    end

    assign speed_1_upgraded = speed_1_upgraded_latched;
    assign speed_2_upgraded = speed_2_upgraded_latched;

endmodule