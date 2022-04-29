module upgrade_bullet (
    input Reset, frame_clk,
    input [9:0] BallX, BallY, Ball2X, Ball2Y, Ball_Size,
    input [9:0] UpgradeX, UpgradeY, Upgrade_Size,
    output bullet_1_upgraded, bullet_2_upgraded, was_collected
);

    logic bullet_1_upgraded_latched, bullet_2_upgraded_latched;

    always_ff @ (posedge Reset or posedge frame_clk)
    begin
        if (Reset)
        begin
            bullet_1_upgraded_latched <= 1'b0;
            bullet_2_upgraded_latched <= 1'b0;
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
                bullet_1_upgraded_latched <= 1'b1;
                bullet_2_upgraded_latched <= 1'b0;
                was_collected <= 1'b1;
            end
            else if ( (Ball2X) >= (UpgradeX - Upgrade_Size) &&
                 (Ball2X) <= (UpgradeX + Upgrade_Size) &&
                 (Ball2Y <= UpgradeY + Upgrade_Size) &&
                 (Ball2Y >= UpgradeY - Upgrade_Size) &&
                 ~was_collected)
            begin
                bullet_1_upgraded_latched <= 1'b0;
                bullet_2_upgraded_latched <= 1'b1;
                was_collected <= 1'b1;
            end

        end
    end

    assign bullet_1_upgraded = bullet_1_upgraded_latched;
    assign bullet_2_upgraded = bullet_2_upgraded_latched;

endmodule