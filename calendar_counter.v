		
module calender(
	input				INCLK,
	input				LEFT,
	input				RIGHT,
	input				UP,
	input				DOWN,
	output	[6:0]		SEVEN_SEGA,
	output				DISP_DP,
	output	[5:0]		SCAN
	);

(*mark_debug = "true"*)wire			sys_clk;
wire			pll_locked;
reg				sys_rst; 

wire			us_f;
wire			ms_f;
wire			s_f;
wire			min_f;
wire			hr_f;

wire	[3:0]	count_secl;
wire	[3:0]	count_sech;
wire	[3:0]	count_minl;
wire	[3:0]	count_minh;
wire	[3:0]	count_hrl;
wire	[3:0]	count_hrh; 

reg		[5:0]	disp_p_r;

wire			left_r;
wire			right_r;
wire			up_r;
wire			DOWN_r;

always @ (posedge sys_clk) 
	sys_rst <= !pll_locked;
	
always @ (posedge sys_clk)
	if (sys_rst)
		disp_p_r <= 8'b11_1110;  
	else
		begin
			if (left_r)
				disp_p_r <= {disp_p_r[4:0], disp_p_r[5]};
			else if (right_r)
				disp_p_r <= {disp_p_r[0], disp_p_r[5:1]};
		end
  

freq_div	freq_div_inst
(
	.SYS_CLK		(sys_clk),
	.SYS_RST		(sys_rst),
	.US_F			(us_f),
	.MS_F			(ms_f),
	.S_F			(s_f)
);
  
dual_num_count	#(
	.PAR_COUNTA		(9),
	.PAR_COUNTB		(5)
)
dual_num_count_sec
(
	.I_SYS_CLK		(sys_clk),
	.I_EXT_RST		(sys_rst),
	.I_ADJ_UP		(up_r),
	.I_ADJ_DOWN		(DOWN_r),
	.I_ADJ_SEL		(disp_p_r[1:0]),
	.I_TRIG_F		(s_f),
	.O_TRIG_F		(min_f),
	.O_COUNTA		(count_secl),
	.O_COUNTB		(count_sech)
);  


dual_num_count	#(
	.PAR_COUNTA		(9),
	.PAR_COUNTB		(5)
)
dual_num_count_min
(
	.I_SYS_CLK		(sys_clk),
	.I_EXT_RST		(sys_rst),
	.I_ADJ_UP		(up_r),
	.I_ADJ_DOWN		(DOWN_r),
	.I_ADJ_SEL		(disp_p_r[3:2]),
	.I_TRIG_F		(min_f),
	.O_TRIG_F		(hr_f),
	.O_COUNTA		(count_minl),
	.O_COUNTB		(count_minh)
);  


dual_num_count_hr  #(
	.PAR_COUNTA		(3),
	.PAR_COUNTB		(2)
)
 dual_num_count_hr
 (
	.I_SYS_CLK		(sys_clk),
	.I_EXT_RST		(sys_rst),
	.I_ADJ_UP		(up_r),
	.I_ADJ_DOWN		(DOWN_r),
	.I_ADJ_SEL		(disp_p_r[5:4]),
	.I_TRIG_F		(hr_f),
	.O_TRIG_F		(),
	.O_COUNTA		(count_hrl),
	.O_COUNTB		(count_hrh)
); 

 seg_disp seg_disp_inst
(
	.SYS_CLK		(sys_clk),
	.EXT_RST		(sys_rst),
	.LEFT_R			(left_r),
	.RIGHT_R		(right_r),
	.MS_F			(ms_f),
	.COUNT_SECL		(count_secl),
	.COUNT_SECH		(count_sech),
	.COUNT_MINL		(count_minl),
	.COUNT_MINH		(count_minh),
	.COUNT_HRL		(count_hrl),
	.COUNT_HRH		(count_hrh),
	.DISP_P			(disp_p_r),
	.SCAN			(SCAN),
	.DISP_DP		(DISP_DP),
	.SEVEN_SEGA		(SEVEN_SEGA)
);

pb_ve pb_ve_LEFT
(
	.SYS_CLK		(sys_clk),
	.SYS_RST		(sys_rst),
	.MS_F			(ms_f),
	.KEYIN			(LEFT),
	.KEYOUT			(left_r)
); 
 
pb_ve pb_ve_right
(
	.SYS_CLK		(sys_clk),
	.SYS_RST		(sys_rst),
	.MS_F			(ms_f),
	.KEYIN			(RIGHT),
	.KEYOUT			(right_r)
);  

pb_ve pb_ve_up
(
	.SYS_CLK		(sys_clk),
	.SYS_RST		(sys_rst),
	.MS_F			(ms_f),
	.KEYIN			(UP),
	.KEYOUT			(up_r)
); 

pb_ve pb_ve_DOWN
(
	.SYS_CLK		(sys_clk),
	.SYS_RST		(sys_rst),
	.MS_F			(ms_f),
	.KEYIN			(DOWN),
	.KEYOUT			(DOWN_r)
);


pll_mod	pll_mod_inst
(
	.areset			(0),
	.inclk0			(INCLK),
	.c0				(sys_clk),
	.locked			(pll_locked)
);

endmodule
