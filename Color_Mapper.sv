/*
    VGA Drawing engine
*/

module color_mapper ( 
    input [9:0] BallX, BallY, Ball2X, Ball2Y, DrawX, DrawY, Ball_size,
    input [9:0] BulletX, BulletY, Bullet2X, Bullet2Y, Bullet_Size, bullet_on, bullet2_on,
    input [9:0] BarrierX, BarrierY, Barrier_Height_Halved, Barrier_Length_Halved,
    input [9:0] Barrier2X, Barrier2Y, Barrier_2_Height_Halved, Barrier_2_Length_Halved,
    input [9:0] Barrier3X, Barrier3Y, Barrier_3_Height_Halved, Barrier_3_Length_Halved,
    input [9:0] Barrier4X, Barrier4Y, Barrier_4_Height_Halved, Barrier_4_Length_Halved,
    input [9:0] Barrier5X, Barrier5Y, Barrier_5_Height_Halved, Barrier_5_Length_Halved,
    input [9:0] Barrier6X, Barrier6Y, Barrier_6_Height_Halved, Barrier_6_Length_Halved,
    input [9:0] Barrier7X, Barrier7Y, Barrier_7_Height_Halved, Barrier_7_Length_Halved,
    input [9:0] UpgradeX, UpgradeY, UpgradeDrawEnable, Upgrade2X, Upgrade2Y, Upgrade2DrawEnable, Upgrade_Size,
    input [9:0] Upgrade3X, Upgrade3Y, Upgrade3DrawEnable, Upgrade4X, Upgrade4Y, Upgrade4DrawEnable,
    input [9:0] ArmorX, ArmorY, Armor_Height_Halved, Armor_Length_Halved, ArmorDrawEnable,
    input [9:0] BarrelX, BarrelY, Barrel_Height_Halved, Barrel_Length_Halved,
    input [9:0] Barrel2X, Barrel2Y, Barrel2_Height_Halved, Barrel2_Length_Halved,
    input blank,
    output logic [7:0] Red, Green, Blue
);

    logic ball_on, ball2_on, draw_bullet, draw_bullet2, barrier_on, armor_on;
	logic draw_speed_upgrade, draw_bullet_upgrade, draw_armor_upgrade;
	  
    int DistX, DistY, Dist2X, Dist2Y, Size;
	assign DistX = DrawX - BulletX;
    assign DistY = DrawY - BulletY;
    assign Dist2X = DrawX - Bullet2X;
    assign Dist2Y = DrawY - Bullet2Y;
    assign Size = Ball_size;
	  
    always_comb
    begin: Drawing_Engine
        if ((DrawX >= BallX - Ball_size) && (DrawX <= BallX + Ball_size) &&
            (DrawY >= BallY - Ball_size) && (DrawY <= BallY + Ball_size)) 
            ball_on = 1'b1;
        else if ((DrawX >= BarrelX - Barrel_Length_Halved) && (DrawX <= BarrelX + Barrel_Length_Halved) &&
            (DrawY >= BarrelY - Barrel_Height_Halved) && (DrawY <= BarrelY + Barrel_Height_Halved)) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
        if ((DrawX >= Ball2X - Ball_size) && (DrawX <= Ball2X + Ball_size) &&
            (DrawY >= Ball2Y - Ball_size) && (DrawY <= Ball2Y + Ball_size)) 
            ball2_on = 1'b1;
        else if ((DrawX >= Barrel2X - Barrel2_Length_Halved) && (DrawX <= Barrel2X + Barrel2_Length_Halved) &&
            (DrawY >= Barrel2Y - Barrel2_Height_Halved) && (DrawY <= Barrel2Y + Barrel2_Height_Halved)) 
            ball2_on = 1'b1;
        else 
            ball2_on = 1'b0;
        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            draw_bullet = 1'b1;
        else 
            draw_bullet = 1'b0;
        if ( ( Dist2X*Dist2X + Dist2Y*Dist2Y) <= (Size * Size) )
            draw_bullet2 = 1'b1;
        else 
            draw_bullet2 = 1'b0;
        if ((DrawX >= BarrierX - Barrier_Length_Halved) && (DrawX <= BarrierX + Barrier_Length_Halved) &&
            (DrawY >= BarrierY - Barrier_Height_Halved) && (DrawY <= BarrierY + Barrier_Height_Halved)) 
            barrier_on = 1'b1;
        else if ((DrawX >= Barrier2X - Barrier_2_Length_Halved) && (DrawX <= Barrier2X + Barrier_2_Length_Halved) &&
            (DrawY >= Barrier2Y - Barrier_2_Height_Halved) && (DrawY <= Barrier2Y + Barrier_2_Height_Halved)) 
            barrier_on = 1'b1;
        else if ((DrawX >= Barrier3X - Barrier_3_Length_Halved) && (DrawX <= Barrier3X + Barrier_3_Length_Halved) &&
            (DrawY >= Barrier3Y - Barrier_3_Height_Halved) && (DrawY <= Barrier3Y + Barrier_3_Height_Halved)) 
            barrier_on = 1'b1;
        else if ((DrawX >= Barrier4X - Barrier_4_Length_Halved) && (DrawX <= Barrier4X + Barrier_4_Length_Halved) &&
            (DrawY >= Barrier4Y - Barrier_4_Height_Halved) && (DrawY <= Barrier4Y + Barrier_4_Height_Halved)) 
            barrier_on = 1'b1;
        else if ((DrawX >= Barrier5X - Barrier_5_Length_Halved) && (DrawX <= Barrier5X + Barrier_5_Length_Halved) &&
            (DrawY >= Barrier5Y - Barrier_5_Height_Halved) && (DrawY <= Barrier5Y + Barrier_5_Height_Halved)) 
            barrier_on = 1'b1;
        else if ((DrawX >= Barrier6X - Barrier_6_Length_Halved) && (DrawX <= Barrier6X + Barrier_6_Length_Halved) &&
            (DrawY >= Barrier6Y - Barrier_6_Height_Halved) && (DrawY <= Barrier6Y + Barrier_6_Height_Halved)) 
            barrier_on = 1'b1;
        else if ((DrawX >= Barrier7X - Barrier_7_Length_Halved) && (DrawX <= Barrier7X + Barrier_7_Length_Halved) &&
            (DrawY >= Barrier7Y - Barrier_7_Height_Halved) && (DrawY <= Barrier7Y + Barrier_7_Height_Halved)) 
            barrier_on = 1'b1;
        else 
            barrier_on = 1'b0;
        if ((DrawX >= UpgradeX - Upgrade_Size) && (DrawX <= UpgradeX + Upgrade_Size) &&
            (DrawY >= UpgradeY - Upgrade_Size) && (DrawY <= UpgradeY + Upgrade_Size) &&
            UpgradeDrawEnable) 
            draw_speed_upgrade = 1'b1;
        else
            draw_speed_upgrade = 1'b0;
        if ((DrawX >= Upgrade2X - Upgrade_Size) && (DrawX <= Upgrade2X + Upgrade_Size) &&
            (DrawY >= Upgrade2Y - Upgrade_Size) && (DrawY <= Upgrade2Y + Upgrade_Size) &&
            Upgrade2DrawEnable) 
            draw_bullet_upgrade = 1'b1;
        else if ((DrawX >= Upgrade4X - Upgrade_Size) && (DrawX <= Upgrade4X + Upgrade_Size) &&
            (DrawY >= Upgrade4Y - Upgrade_Size) && (DrawY <= Upgrade4Y + Upgrade_Size) &&
            Upgrade4DrawEnable) 
            draw_bullet_upgrade = 1'b1;
        else
            draw_bullet_upgrade = 1'b0;
        if ((DrawX >= Upgrade3X - Upgrade_Size) && (DrawX <= Upgrade3X + Upgrade_Size) &&
            (DrawY >= Upgrade3Y - Upgrade_Size) && (DrawY <= Upgrade3Y + Upgrade_Size) &&
            Upgrade3DrawEnable) 
            draw_armor_upgrade = 1'b1;
        else
            draw_armor_upgrade = 1'b0;
        if ((DrawX >= ArmorX - Armor_Length_Halved) && (DrawX <= ArmorX + Armor_Length_Halved) &&
            (DrawY >= ArmorY - Armor_Height_Halved) && (DrawY <= ArmorY + Armor_Height_Halved) &&
            ArmorDrawEnable) 
            armor_on = 1'b1;
        else  
            armor_on = 1'b0;
     end 
       
    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h00;
        end
        else if ((draw_bullet == 1'b1) && (bullet_on == 1'b1))
        begin 
            Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h00;
        end
        else if ((ball2_on == 1'b1))
        begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hff;
        end
        else if ((draw_bullet2 == 1'b1) && (bullet2_on == 1'b1))
        begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hff;
        end
        else if (barrier_on)
        begin
            Red = 8'hff;
            Green = 8'h7f;
            Blue = 8'h00;
        end
        else if (draw_speed_upgrade)
        begin
            Red = 8'hAA;
            Green = 8'h2C;
            Blue = 8'hFA;
        end
        else if (draw_bullet_upgrade)
        begin
            Red = 8'h11;
            Green = 8'hFC;
            Blue = 8'h11;
        end
        else if (draw_armor_upgrade || armor_on)
        begin
            Red = 8'hFF;
            Green = 8'hFF;
            Blue = 8'h00;
        end
        else if (~blank)
        begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
        end
        else 
        begin 
            Red = 8'h70; 
            Green = 8'h70;
            Blue = 8'h7f;
        end      
    end 
    
endmodule
