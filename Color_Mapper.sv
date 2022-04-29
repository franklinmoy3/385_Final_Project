/*
    VGA Drawing engine
*/

module color_mapper ( 
    input [9:0] BallX, BallY, Ball2X, Ball2Y, DrawX, DrawY, Ball_size,
    input [9:0] BulletX, BulletY, Bullet2X, Bullet2Y, Bullet_Size, bullet_on, bullet2_on,
    input [9:0] BarrierX, BarrierY, Barrier_Height_Halved, Barrier_Length_Halved,
    input [9:0] Barrier2X, Barrier2Y, Barrier_2_Height_Halved, Barrier_2_Length_Halved,
    input blank,
    output logic [7:0] Red, Green, Blue
);
    
    logic ball_on, ball2_on, draw_bullet, draw_bullet2, barrier_on;
	 
	  
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
        else 
            ball_on = 1'b0;
        if ((DrawX >= Ball2X - Ball_size) && (DrawX <= Ball2X + Ball_size) &&
            (DrawY >= Ball2Y - Ball_size) && (DrawY <= Ball2Y + Ball_size)) 
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
        else 
            barrier_on = 1'b0;
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
            Red = 8'h00;
            Green = 8'hff;
            Blue = 8'hff;
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
