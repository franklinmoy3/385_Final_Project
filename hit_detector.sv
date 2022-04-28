/*
    Module for bullet hit detection against players
*/

module hit_detector (
    input Reset, frame_clk,
    input [9:0] BallX, BallY, Ball2X, Ball2Y, Ball_Size,
    input [9:0] BulletX, BulletY, Bullet2X, Bullet2Y, Bullet_Size,
    output player_1_hit, player_2_hit
);

    logic p1_hit_latched, p2_hit_latched;

    always_ff @ (posedge Reset or posedge frame_clk)
    begin
        if (Reset)
        begin
            p1_hit_latched <= 1'b0;
            p2_hit_latched <= 1'b0;
        end

        else
        begin
            // P1 bullet's right side hits P2
            if ( (BulletX + Bullet_Size) >= (Ball2X - Ball_Size) &&
                 (BulletX + Bullet_Size) <= (Ball2X + Ball_Size) &&
                 (BulletY <= Ball2Y + Ball_Size) &&
                 (BulletY >= Ball2Y - Ball_Size) )
                    p2_hit_latched <= 1'b1;

            // P1 bullet's left side hits P2
            else if ( (BulletX - Bullet_Size) >= (Ball2X - Ball_Size) &&
                 (BulletX - Bullet_Size) <= (Ball2X + Ball_Size) &&
                 (BulletY <= Ball2Y + Ball_Size) &&
                 (BulletY >= Ball2Y - Ball_Size) )
                    p2_hit_latched <= 1'b1;
            
            // P1 bullet's bottom side hits P2
            else if ( (BulletY + Bullet_Size) >= (Ball2Y - Ball_Size) &&
                 (BulletY + Bullet_Size) <= (Ball2Y + Ball_Size) &&
                 (BulletX <= Ball2X + Ball_Size) &&
                 (BulletX >= Ball2X - Ball_Size) )
                    p2_hit_latched <= 1'b1;
            
            // P1 bullet's top side hits P2
            else if ( (BulletY - Bullet_Size) >= (Ball2Y - Ball_Size) &&
                 (BulletY - Bullet_Size) <= (Ball2Y + Ball_Size) &&
                 (BulletX <= Ball2X + Ball_Size) &&
                 (BulletX >= Ball2X - Ball_Size) )
                    p2_hit_latched <= 1'b1;

            else
                p2_hit_latched <= 1'b0;

            // P2 bullet's right side hits P1
            if ( (Bullet2X + Bullet_Size) >= (BallX - Ball_Size) &&
                 (Bullet2X + Bullet_Size) <= (BallX + Ball_Size) &&
                 (Bullet2Y <= BallY + Ball_Size) &&
                 (Bullet2Y >= BallY - Ball_Size) )
                    p1_hit_latched <= 1'b1;

            // P2 bullet's left side hits P1
            else if ( (Bullet2X - Bullet_Size) >= (BallX - Ball_Size) &&
                 (Bullet2X - Bullet_Size) <= (BallX + Ball_Size) &&
                 (Bullet2Y <= BallY + Ball_Size) &&
                 (Bullet2Y >= BallY - Ball_Size) )
                    p1_hit_latched <= 1'b1;
            
            // P2 bullet's bottom side hits P1
            else if ( (Bullet2Y + Bullet_Size) >= (BallY - Ball_Size) &&
                 (Bullet2Y + Bullet_Size) <= (BallY + Ball_Size) &&
                 (Bullet2X <= BallX + Ball_Size) &&
                 (Bullet2X >= BallX - Ball_Size) )
                    p1_hit_latched <= 1'b1;
            
            // P2 bullet's top side hits P1
            else if ( (Bullet2Y - Bullet_Size) >= (BallY - Ball_Size) &&
                 (Bullet2Y - Bullet_Size) <= (BallY + Ball_Size) &&
                 (Bullet2X <= BallX + Ball_Size) &&
                 (Bullet2X >= BallX - Ball_Size) )
                    p1_hit_latched <= 1'b1;

            else
                p1_hit_latched <= 1'b0;

        end
    end

    assign player_1_hit = p1_hit_latched;
    assign player_2_hit = p2_hit_latched;

endmodule