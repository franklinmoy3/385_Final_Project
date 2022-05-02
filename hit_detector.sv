/*
    Module for bullet hit detection against players
*/

module hit_detector (
    input Reset, frame_clk,
    input [9:0] BallX, BallY, Ball2X, Ball2Y, Ball_Size,
    input [9:0] BulletX, BulletY, Bullet2X, Bullet2Y, Bullet_Size,
    input [9:0] ArmorX, ArmorY, Armor_Height_Halved, Armor_Length_Halved,
    input ArmorEnabled,
    output player_1_hit, player_2_hit, bullet_on_bullet_hit, armor_hit,
    output [4:0] player_1_score, player_2_score
);

    logic p1_hit_latched, p2_hit_latched;
    
    always_ff @ (posedge Reset or posedge frame_clk)
    begin
        if (Reset)
        begin
            p1_hit_latched <= 1'b0;
            p2_hit_latched <= 1'b0;
            // armor_hit <= 1'b0;
            // bullet_on_bullet_hit <= 1'b0;
            player_1_score <= 5'b0;
            player_2_score <= 5'b0;
        end

        else
        begin
            // P1 bullet's right side hits P2
            if ( (BulletX + Bullet_Size) >= (Ball2X - Ball_Size) &&
                 (BulletX + Bullet_Size) <= (Ball2X + Ball_Size) &&
                 (BulletY <= Ball2Y + Ball_Size) &&
                 (BulletY >= Ball2Y - Ball_Size))
                begin
                    p2_hit_latched <= 1'b1;
                    player_1_score <= player_1_score + 1'b1;
                end

            // P1 bullet's left side hits P2
            else if ( (BulletX - Bullet_Size) >= (Ball2X - Ball_Size) &&
                 (BulletX - Bullet_Size) <= (Ball2X + Ball_Size) &&
                 (BulletY <= Ball2Y + Ball_Size) &&
                 (BulletY >= Ball2Y - Ball_Size))
            begin
                    p2_hit_latched <= 1'b1;
                    player_1_score <= player_1_score + 1'b1;
            end
            
            // P1 bullet's bottom side hits P2
            else if ( (BulletY + Bullet_Size) >= (Ball2Y - Ball_Size) &&
                 (BulletY + Bullet_Size) <= (Ball2Y + Ball_Size) &&
                 (BulletX <= Ball2X + Ball_Size) &&
                 (BulletX >= Ball2X - Ball_Size))
            begin
                    p2_hit_latched <= 1'b1;
                    player_1_score <= player_1_score + 1'b1;
            end

            // P1 bullet's top side hits P2
            else if ( (BulletY - Bullet_Size) >= (Ball2Y - Ball_Size) &&
                 (BulletY - Bullet_Size) <= (Ball2Y + Ball_Size) &&
                 (BulletX <= Ball2X + Ball_Size) &&
                 (BulletX >= Ball2X - Ball_Size))
            begin
                    p2_hit_latched <= 1'b1;
                    player_1_score <= player_1_score + 1'b1;
            end

            else
                p2_hit_latched <= 1'b0;

            // P2 bullet's right side hits P1
            if ( (Bullet2X + Bullet_Size) >= (BallX - Ball_Size) &&
                 (Bullet2X + Bullet_Size) <= (BallX + Ball_Size) &&
                 (Bullet2Y <= BallY + Ball_Size) &&
                 (Bullet2Y >= BallY - Ball_Size))
            begin
                    p1_hit_latched <= 1'b1;
                    player_2_score <= player_2_score + 1'b1;
            end

            // P2 bullet's left side hits P1
            else if ( (Bullet2X - Bullet_Size) >= (BallX - Ball_Size) &&
                 (Bullet2X - Bullet_Size) <= (BallX + Ball_Size) &&
                 (Bullet2Y <= BallY + Ball_Size) &&
                 (Bullet2Y >= BallY - Ball_Size))
            begin
                    p1_hit_latched <= 1'b1;
                    player_2_score <= player_2_score + 1'b1;
            end
            
            // P2 bullet's bottom side hits P1
            else if ( (Bullet2Y + Bullet_Size) >= (BallY - Ball_Size) &&
                 (Bullet2Y + Bullet_Size) <= (BallY + Ball_Size) &&
                 (Bullet2X <= BallX + Ball_Size) &&
                 (Bullet2X >= BallX - Ball_Size))
            begin
                    p1_hit_latched <= 1'b1;
                    player_2_score <= player_2_score + 1'b1;
            end
            
            // P2 bullet's top side hits P1
            else if ( (Bullet2Y - Bullet_Size) >= (BallY - Ball_Size) &&
                 (Bullet2Y - Bullet_Size) <= (BallY + Ball_Size) &&
                 (Bullet2X <= BallX + Ball_Size) &&
                 (Bullet2X >= BallX - Ball_Size))
            begin
                    p1_hit_latched <= 1'b1;
                    player_2_score <= player_2_score + 1'b1;
            end

            else
                p1_hit_latched <= 1'b0;
        end
    end

    always_comb
    begin
        // Bullet hits armor
            if (ArmorEnabled)
            begin
                if ( (Bullet2X - Bullet_Size) >= (ArmorX - Armor_Length_Halved) &&
                 (Bullet2X - Bullet_Size) <= (ArmorX + Armor_Length_Halved) &&
                 (Bullet2Y <= ArmorY + Armor_Height_Halved) &&
                 (Bullet2Y >= ArmorY - Armor_Height_Halved))
                    armor_hit = 1'b1;

                else if ( (Bullet2X + Bullet_Size) >= (ArmorX - Armor_Length_Halved) &&
                    (Bullet2X + Bullet_Size) <= (ArmorX + Armor_Length_Halved) &&
                    (Bullet2Y <= ArmorY + Armor_Height_Halved) &&
                    (Bullet2Y >= ArmorY - Armor_Height_Halved))
                        armor_hit = 1'b1;
                
                else if ( (Bullet2Y - Bullet_Size) >= (ArmorY - Armor_Height_Halved) &&
                    (Bullet2Y - Bullet_Size) <= (ArmorY + Armor_Height_Halved) &&
                    (Bullet2X <= ArmorX + Armor_Length_Halved) &&
                    (Bullet2X >= ArmorX - Armor_Length_Halved))
                        armor_hit = 1'b1;
                
                else if ( (Bullet2Y + Bullet_Size) >= (ArmorY - Armor_Height_Halved) &&
                    (Bullet2Y + Bullet_Size) <= (ArmorY + Armor_Height_Halved) &&
                    (Bullet2X <= ArmorX + Armor_Length_Halved) &&
                    (Bullet2X >= ArmorX - Armor_Length_Halved))
                        armor_hit = 1'b1;

                else if ( (BulletX - Bullet_Size) >= (ArmorX - Armor_Length_Halved) &&
                    (BulletX - Bullet_Size) <= (ArmorX + Armor_Length_Halved) &&
                    (BulletY <= ArmorY + Armor_Height_Halved) &&
                    (BulletY >= ArmorY - Armor_Height_Halved))
                        armor_hit = 1'b1;

                else if ( (BulletX + Bullet_Size) >= (ArmorX - Armor_Length_Halved) &&
                    (BulletX + Bullet_Size) <= (ArmorX + Armor_Length_Halved) &&
                    (BulletY <= ArmorY + Armor_Height_Halved) &&
                    (BulletY >= ArmorY - Armor_Height_Halved))
                        armor_hit = 1'b1;
                
                else if ( (BulletY - Bullet_Size) >= (ArmorY - Armor_Height_Halved) &&
                    (BulletY - Bullet_Size) <= (ArmorY + Armor_Height_Halved) &&
                    (BulletX <= ArmorX + Armor_Length_Halved) &&
                    (BulletX >= ArmorX - Armor_Length_Halved))
                        armor_hit = 1'b1;
                
                else if ( (BulletY + Bullet_Size) >= (ArmorY - Armor_Height_Halved) &&
                    (BulletY + Bullet_Size) <= (ArmorY + Armor_Height_Halved) &&
                    (BulletX <= ArmorX + Armor_Length_Halved) &&
                    (BulletX >= ArmorX - Armor_Length_Halved))
                        armor_hit = 1'b1;

                else
                    armor_hit = 1'b0;
            end
            else
                armor_hit = 1'b0;

        // Both bullets hit each other (added extra padding due to sync delay)
        if ( (Bullet2X) >= (BulletX - Bullet_Size - 10) &&
                (Bullet2X) <= (BulletX + Bullet_Size + 10) &&
                (Bullet2Y <= BulletY + Bullet_Size) &&
                (Bullet2Y >= BulletY - Bullet_Size))
                bullet_on_bullet_hit = 1'b1;

        else if ( (Bullet2X) >= (BulletX - Bullet_Size - 10) &&
                (Bullet2X) <= (BulletX + Bullet_Size + 10) &&
                (Bullet2Y <= BulletY + Bullet_Size) &&
                (Bullet2Y >= BulletY - Bullet_Size))
                bullet_on_bullet_hit = 1'b1;
        
        else if ( (Bullet2Y) >= (BulletY - Bullet_Size - 10) &&
                (Bullet2Y) <= (BulletY + Bullet_Size + 10) &&
                (Bullet2X <= BulletX + Bullet_Size) &&
                (Bullet2X >= BulletX - Bullet_Size))
                bullet_on_bullet_hit = 1'b1;
        
        else if ( (Bullet2Y) >= (BulletY - Bullet_Size - 10) &&
                (Bullet2Y) <= (BulletY + Bullet_Size + 10) &&
                (Bullet2X <= BulletX + Bullet_Size) &&
                (Bullet2X >= BulletX - Bullet_Size))
                bullet_on_bullet_hit = 1'b1;

        else
            bullet_on_bullet_hit = 1'b0;
    end

    assign player_1_hit = p1_hit_latched;
    assign player_2_hit = p2_hit_latched;
    
endmodule