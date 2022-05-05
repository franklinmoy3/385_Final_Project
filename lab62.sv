//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab62 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);

logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ball2xsig, ball2ysig, ballsizesig;
	logic [9:0] bulletxsig, bulletysig, bullet2xsig, bullet2ysig, bulletsizesig;
	logic bulletOnSig, bullet2OnSig;
	logic [7:0] Red, Blue, Green;
	// keycode meanings: P1 movement, P2 movement, P1 fire, P2 fire
	logic [7:0] keycode, keycode1, keycode2, keycode3;
	logic [1:0] p1_direction, p2_direction;
	logic player_1_hit, player_2_hit, new_round, bullet_on_bullet_hit;
	logic [7:0] player_1_score, player_2_score;
	logic [3:0] p1_barrier_collision, p2_barrier_collision;
	logic b1_barrier_collision, b2_barrier_collision;
	logic [3:0] p1_barrier_collision_1, p2_barrier_collision_1, p1_barrier_collision_2, p2_barrier_collision_2;
	logic [3:0] p1_barrier_collision_3, p2_barrier_collision_3, p1_barrier_collision_4, p2_barrier_collision_4;
	logic [3:0] p1_barrier_collision_5, p2_barrier_collision_5, p1_barrier_collision_6, p2_barrier_collision_6;
	logic [3:0] p1_barrier_collision_7, p2_barrier_collision_7;
	logic b1_barrier_collision_1, b2_barrier_collision_1, b1_barrier_collision_2, b2_barrier_collision_2;
	logic b1_barrier_collision_3, b2_barrier_collision_3, b1_barrier_collision_4, b2_barrier_collision_4;
	logic b1_barrier_collision_5, b2_barrier_collision_5, b1_barrier_collision_6, b2_barrier_collision_6;
	logic b1_barrier_collision_7, b2_barrier_collision_7;
	logic bullet_1_upgraded, bullet_2_upgraded, bullet_was_collected;
	logic bullet_1_upgraded_2, bullet_2_upgraded_2, bullet_was_collected_2;
	logic speed_1_upgraded, speed_2_upgraded, speed_was_collected;
	logic armor_was_collected, armor_hit;
	logic [9:0] ArmorX, ArmorY, Armor_Height_Halved, Armor_Length_Halved;
	logic [9:0] Random_BarrierX, Random_BarrierY, Random_Barrier_Height, Random_Barrier_Length;
	logic [9:0] Random_BarrierX_2, Random_BarrierY_2, Random_Barrier_Height_2, Random_Barrier_Length_2;
	logic [9:0] Random_BarrierX_3, Random_BarrierY_3, Random_Barrier_Height_3, Random_Barrier_Length_3;
	logic [9:0] Random_BarrierX_4, Random_BarrierY_4, Random_Barrier_Height_4, Random_Barrier_Length_4;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	fp_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi_0_SS_n(SPI0_CS_N),
		.spi_0_MOSI(SPI0_MOSI),
		.spi_0_MISO(SPI0_MISO),
		.spi_0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export(),
		.leds_pio_export({hundreds, signs, LEDR}),
		.keycode_export(keycode),
		.keycode_1_export(keycode1),
		.keycode_2_export(keycode2),
		.keycode_3_export(keycode3)
	 );

	assign hex_num_3 = player_1_score[3:0];
	assign hex_num_4 = player_1_score[4];
	assign hex_num_0 = player_2_score[3:0];
	assign hex_num_1 = player_2_score[4]; 
	assign new_round = player_1_hit | player_2_hit;
	assign p1_barrier_collision = p1_barrier_collision_1 | p1_barrier_collision_2 | p1_barrier_collision_3 | p1_barrier_collision_4 | p1_barrier_collision_5 | p1_barrier_collision_6 | p1_barrier_collision_7;
	assign p2_barrier_collision = p2_barrier_collision_1 | p2_barrier_collision_2 | p2_barrier_collision_3 | p2_barrier_collision_4 | p2_barrier_collision_5 | p2_barrier_collision_6 | p2_barrier_collision_7;
	assign b1_barrier_collision = b1_barrier_collision_1 | b1_barrier_collision_2 | b1_barrier_collision_3 | b1_barrier_collision_4 | b1_barrier_collision_5 | b1_barrier_collision_6 | b1_barrier_collision_7;
	assign b2_barrier_collision = b2_barrier_collision_1 | b2_barrier_collision_2 | b2_barrier_collision_3 | b2_barrier_collision_4 | b2_barrier_collision_5 | b2_barrier_collision_6 | b2_barrier_collision_7;
	assign Reset_arena = Reset_h | new_round;

	// Form upgrade coords like this '{UpgradeX, UpgradeY}
	parameter int ub_coords[2] = '{320, 320};
	parameter int ub2_coords[2] = '{320, 160};
	parameter int us_coords[2] = '{340, 400};
	parameter int ua_coords[2] = '{300, 15};
	parameter [9:0] collectable_size = 9'd4;

	upgrade_bullet ub(.Reset(Reset_arena), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball_Size(ballsizesig), .UpgradeX(ub_coords[0]), .UpgradeY(ub_coords[1]), .Upgrade_Size(collectable_size), .bullet_1_upgraded(bullet_1_upgraded), .bullet_2_upgraded(bullet_2_upgraded), .was_collected(bullet_was_collected));
	upgrade_bullet ub2(.Reset(Reset_arena), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball_Size(ballsizesig), .UpgradeX(ub2_coords[0]), .UpgradeY(ub2_coords[1]), .Upgrade_Size(collectable_size), .bullet_1_upgraded(bullet_1_upgraded_2), .bullet_2_upgraded(bullet_2_upgraded_2), .was_collected(bullet_was_collected_2));
	upgrade_speed us(.Reset(Reset_arena), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball_Size(ballsizesig), .UpgradeX(us_coords[0]), .UpgradeY(us_coords[1]), .Upgrade_Size(collectable_size), .speed_1_upgraded(speed_1_upgraded), .speed_2_upgraded(speed_2_upgraded), .was_collected(speed_was_collected));
	upgrade_armor ua(.Reset(Reset_arena), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball_Size(ballsizesig), .UpgradeX(ua_coords[0]), .UpgradeY(ua_coords[1]), .Upgrade_Size(collectable_size), .was_collected(armor_was_collected), .Armor_Height_Halved(Armor_Height_Halved), .Armor_Length_Halved(Armor_Length_Halved), .ArmorX(ArmorX), .ArmorY(ArmorY), .p1_direction(p1_direction), .p2_direction(p2_direction));

	// Form barrier params like this: '{BarrierX, BarrierY, Barrier_Height_Halved, Barrier_Length_Halved}
	parameter int barrier_1_params[4] = '{320, 200, 10, 40};
	parameter int barrier_2_params[4] = '{320, 240, 30, 20};
	parameter int barrier_3_params[4] = '{320, 280, 10, 40};

	barrier_param_gen bpg(.Reset(Reset_arena), .Clk(VGA_VS), .Base(24'h0), .Random_BarrierX(Random_BarrierX), .Random_BarrierY(Random_BarrierY), .Random_Barrier_Height(Random_Barrier_Height), .Random_Barrier_Length(Random_Barrier_Length));
	barrier_param_gen bpg2(.Reset(Reset_arena), .Clk(VGA_VS), .Base(24'h19285F), .Random_BarrierX(Random_BarrierX_2), .Random_BarrierY(Random_BarrierY_2), .Random_Barrier_Height(Random_Barrier_Height_2), .Random_Barrier_Length(Random_Barrier_Length_2));
	barrier_param_gen bpg3(.Reset(Reset_arena), .Clk(VGA_VS), .Base(24'h111111), .Random_BarrierX(Random_BarrierX_3), .Random_BarrierY(Random_BarrierY_3), .Random_Barrier_Height(Random_Barrier_Height_3), .Random_Barrier_Length(Random_Barrier_Length_3));
	barrier_param_gen bpg4(.Reset(Reset_arena), .Clk(VGA_VS), .Base(24'hABCDEF), .Random_BarrierX(Random_BarrierX_4), .Random_BarrierY(Random_BarrierY_4), .Random_Barrier_Height(Random_Barrier_Height_4), .Random_Barrier_Length(Random_Barrier_Length_4));
	
	barrier b1(.Reset(Reset_arena), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball_Size(ballsizesig), .BulletX(bulletxsig), .BulletY(bulletysig), .Bullet2X(bullet2xsig), .Bullet2Y(bullet2ysig), .Bullet_Size(bulletsizesig), .BarrierX(barrier_1_params[0]), .BarrierY(barrier_1_params[1]), .Barrier_Height_Halved(barrier_1_params[2]), .Barrier_Length_Halved(barrier_1_params[3]), .player_1_collision(p1_barrier_collision_1), .player_2_collision(p2_barrier_collision_1), .bullet_1_collision(b1_barrier_collision_1), .bullet_2_collision(b2_barrier_collision_1));
	barrier b2(.Reset(Reset_arena), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball_Size(ballsizesig), .BulletX(bulletxsig), .BulletY(bulletysig), .Bullet2X(bullet2xsig), .Bullet2Y(bullet2ysig), .Bullet_Size(bulletsizesig), .BarrierX(barrier_2_params[0]), .BarrierY(barrier_2_params[1]), .Barrier_Height_Halved(barrier_2_params[2]), .Barrier_Length_Halved(barrier_2_params[3]), .player_1_collision(p1_barrier_collision_2), .player_2_collision(p2_barrier_collision_2), .bullet_1_collision(b1_barrier_collision_2), .bullet_2_collision(b2_barrier_collision_2));
	barrier b3(.Reset(Reset_arena), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball_Size(ballsizesig), .BulletX(bulletxsig), .BulletY(bulletysig), .Bullet2X(bullet2xsig), .Bullet2Y(bullet2ysig), .Bullet_Size(bulletsizesig), .BarrierX(barrier_3_params[0]), .BarrierY(barrier_3_params[1]), .Barrier_Height_Halved(barrier_3_params[2]), .Barrier_Length_Halved(barrier_3_params[3]), .player_1_collision(p1_barrier_collision_3), .player_2_collision(p2_barrier_collision_3), .bullet_1_collision(b1_barrier_collision_3), .bullet_2_collision(b2_barrier_collision_3));
	barrier b4(.Reset(Reset_arena), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball_Size(ballsizesig), .BulletX(bulletxsig), .BulletY(bulletysig), .Bullet2X(bullet2xsig), .Bullet2Y(bullet2ysig), .Bullet_Size(bulletsizesig), .BarrierX(Random_BarrierX), .BarrierY(Random_BarrierY), .Barrier_Height_Halved(Random_Barrier_Height), .Barrier_Length_Halved(Random_Barrier_Length), .player_1_collision(p1_barrier_collision_4), .player_2_collision(p2_barrier_collision_4), .bullet_1_collision(b1_barrier_collision_4), .bullet_2_collision(b2_barrier_collision_4));
	barrier b5(.Reset(Reset_arena), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball_Size(ballsizesig), .BulletX(bulletxsig), .BulletY(bulletysig), .Bullet2X(bullet2xsig), .Bullet2Y(bullet2ysig), .Bullet_Size(bulletsizesig), .BarrierX(Random_BarrierX_2), .BarrierY(Random_BarrierY_2), .Barrier_Height_Halved(Random_Barrier_Height_2), .Barrier_Length_Halved(Random_Barrier_Length_2), .player_1_collision(p1_barrier_collision_5), .player_2_collision(p2_barrier_collision_5), .bullet_1_collision(b1_barrier_collision_5), .bullet_2_collision(b2_barrier_collision_5));
	barrier b6(.Reset(Reset_arena), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball_Size(ballsizesig), .BulletX(bulletxsig), .BulletY(bulletysig), .Bullet2X(bullet2xsig), .Bullet2Y(bullet2ysig), .Bullet_Size(bulletsizesig), .BarrierX(Random_BarrierX_3), .BarrierY(Random_BarrierY_3), .Barrier_Height_Halved(Random_Barrier_Height_3), .Barrier_Length_Halved(Random_Barrier_Length_3), .player_1_collision(p1_barrier_collision_6), .player_2_collision(p2_barrier_collision_6), .bullet_1_collision(b1_barrier_collision_6), .bullet_2_collision(b2_barrier_collision_6));
	barrier b7(.Reset(Reset_arena), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball_Size(ballsizesig), .BulletX(bulletxsig), .BulletY(bulletysig), .Bullet2X(bullet2xsig), .Bullet2Y(bullet2ysig), .Bullet_Size(bulletsizesig), .BarrierX(Random_BarrierX_4), .BarrierY(Random_BarrierY_4), .Barrier_Height_Halved(Random_Barrier_Height_4), .Barrier_Length_Halved(Random_Barrier_Length_4), .player_1_collision(p1_barrier_collision_7), .player_2_collision(p2_barrier_collision_7), .bullet_1_collision(b1_barrier_collision_7), .bullet_2_collision(b2_barrier_collision_7));

	tank ball(.Reset(Reset_arena), .frame_clk(VGA_VS), .keycode(keycode), .BallX(ballxsig), .BallY(ballysig), .BallS(ballsizesig), .direction(p1_direction), .barrier_collision(p1_barrier_collision), .speed_upgrade(speed_1_upgraded));
	tank2 ball2(.Reset(Reset_arena), .frame_clk(VGA_VS), .keycode(keycode1), .BallX(ball2xsig), .BallY(ball2ysig), .BallS(), .direction(p2_direction), .barrier_collision(p2_barrier_collision), .speed_upgrade(speed_2_upgraded));
	
	bullet bullet(.Reset(Reset_arena), .frame_clk(VGA_VS), .keycode(keycode2), .BallX(ballxsig), .BallY(ballysig), .BallS(ballsizesig), .BulletX(bulletxsig), .BulletY(bulletysig), .BulletS(bulletsizesig), .bullet_on(bulletOnSig), .direction(p1_direction), .barrier_collision(b1_barrier_collision), .player_hit(new_round), .upgraded(bullet_1_upgraded | bullet_1_upgraded_2), .bullet_on_bullet_hit(bullet_on_bullet_hit), .armor_hit(armor_hit));
	bullet2 bullet2(.Reset(Reset_arena), .frame_clk(VGA_VS), .keycode(keycode3), .BallX(ball2xsig), .BallY(ball2ysig), .BallS(ballsizesig), .BulletX(bullet2xsig), .BulletY(bullet2ysig), .BulletS(), .bullet_on(bullet2OnSig), .direction(p2_direction), .barrier_collision(b2_barrier_collision), .player_hit(new_round), .upgraded(bullet_2_upgraded | bullet_2_upgraded_2), .bullet_on_bullet_hit(bullet_on_bullet_hit), .armor_hit(armor_hit));
	hit_detector hd(.Reset(Reset_h), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball_Size(ballsizesig), .BulletX(bulletxsig), .BulletY(bulletysig), .Bullet2X(bullet2xsig), .Bullet2Y(bullet2ysig), .Bullet_Size(bulletsizesig), .player_1_hit(player_1_hit), .player_2_hit(player_2_hit), .player_1_score(player_1_score), .player_2_score(player_2_score), .bullet_on_bullet_hit(bullet_on_bullet_hit), .armor_hit(armor_hit), .ArmorEnabled(armor_was_collected), .Armor_Height_Halved, .Armor_Length_Halved, .ArmorX, .ArmorY);
	
	vga_controller vga(.Clk(MAX10_CLK1_50), .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_Clk), .blank(blank), .sync(sync), .DrawX(drawxsig), .DrawY(drawysig));
	color_mapper colormapper(.BallX(ballxsig), .BallY(ballysig), .Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball_size(ballsizesig),
							 .DrawX(drawxsig), .DrawY(drawysig), .Red(Red), .Green(Green), .Blue(Blue), .blank(blank),
							 .BulletX(bulletxsig), .BulletY(bulletysig), .Bullet2X(bullet2xsig), .Bullet2Y(bullet2ysig),
							 .Bullet_Size(bulletsizesig), .bullet_on(bulletOnSig), .bullet2_on(bullet2OnSig),
							 .BarrierX(barrier_1_params[0]), .BarrierY(barrier_1_params[1]), .Barrier_Height_Halved(barrier_1_params[2]), .Barrier_Length_Halved(barrier_1_params[3]),
							 .Barrier2X(barrier_2_params[0]), .Barrier2Y(barrier_2_params[1]), .Barrier_2_Height_Halved(barrier_2_params[2]), .Barrier_2_Length_Halved(barrier_2_params[3]),
							 .Barrier3X(barrier_3_params[0]), .Barrier3Y(barrier_3_params[1]), .Barrier_3_Height_Halved(barrier_3_params[2]), .Barrier_3_Length_Halved(barrier_3_params[3]),
							 .Barrier4X(Random_BarrierX), .Barrier4Y(Random_BarrierY), .Barrier_4_Height_Halved(Random_Barrier_Height), .Barrier_4_Length_Halved(Random_Barrier_Length),
							 .Barrier5X(Random_BarrierX_2), .Barrier5Y(Random_BarrierY_2), .Barrier_5_Height_Halved(Random_Barrier_Height_2), .Barrier_5_Length_Halved(Random_Barrier_Length_2),
							 .Barrier6X(Random_BarrierX_3), .Barrier6Y(Random_BarrierY_3), .Barrier_6_Height_Halved(Random_Barrier_Height_3), .Barrier_6_Length_Halved(Random_Barrier_Length_3),
							 .Barrier7X(Random_BarrierX_4), .Barrier7Y(Random_BarrierY_4), .Barrier_7_Height_Halved(Random_Barrier_Height_4), .Barrier_7_Length_Halved(Random_Barrier_Length_4),
							 .Upgrade_Size(collectable_size), .UpgradeX(us_coords[0]), .UpgradeY(us_coords[1]), .UpgradeDrawEnable(~speed_was_collected), .Upgrade2X(ub_coords[0]), .Upgrade2Y(ub_coords[1]), .Upgrade2DrawEnable(~bullet_was_collected),
							 .Upgrade3X(ua_coords[0]), .Upgrade3Y(ua_coords[1]), .Upgrade3DrawEnable(~armor_was_collected),
							 .Upgrade4X(ub2_coords[0]), .Upgrade4Y(ub2_coords[1]), .Upgrade4DrawEnable(~bullet_was_collected_2),
							 .ArmorX(ArmorX), .ArmorY(ArmorY), .Armor_Height_Halved(Armor_Height_Halved), .Armor_Length_Halved(Armor_Length_Halved), .ArmorDrawEnable(armor_was_collected));

endmodule
