
module seg_disp
(
	input			    	SYS_CLK,
	input			    	EXT_RST,
	input			    	LEFT_R,
	input			    	RIGHT_R,
	input			    	MS_F,
	input	[3:0]	    	COUNT_SECL,
	input	[3:0]	    	COUNT_SECH,
	input	[3:0]	    	COUNT_MINL,
	input	[3:0]	    	COUNT_MINH,
	input	[3:0]	    	COUNT_HRL,
	input	[3:0]	    	COUNT_HRH,
	input	[5:0]			DISP_P,
	output	reg [5:0]		SCAN,
	output	reg		    	DISP_DP,
	output	reg [7:0]		SEVEN_SEGA
);

reg [3:0]	counta;
reg [2:0]	scan_st;
reg [6:0]	seven_seg_ra;
 
always @ (posedge SYS_CLK)
	if (EXT_RST)
		begin
			SCAN <= 6'b11_1111; 
			counta <= 4'b0;
			DISP_DP <= 1'b1;
			scan_st <= 0;
		end
	else
		case (scan_st)
			0:
				begin
					SCAN <= 6'b11_1110;
					counta <= COUNT_SECL;
					DISP_DP <= DISP_P[0];
					if (MS_F)
						scan_st <= 1;
				end
			1:
				begin
					SCAN <= 6'b11_1101;
					counta <= COUNT_SECH;
					DISP_DP	<= DISP_P[1];
					if (MS_F)
						scan_st <= 2;
				end
			2:
				begin
					SCAN <= 6'b11_1011;
					counta <= COUNT_MINL;
					DISP_DP <= DISP_P[2];
					if (MS_F)
						scan_st <= 3;
				end
			3:
				begin
					SCAN <= 6'b11_0111;
					counta <= COUNT_MINH;
					DISP_DP <= DISP_P[3];
					if (MS_F)
						scan_st <= 4;  
				end 
			4:
				begin
					SCAN <= 6'b10_1111;
					counta <= COUNT_HRL;
					DISP_DP <= DISP_P[4];
					if (MS_F)
						scan_st <= 5;

				end 
			5:
				begin
					SCAN <= 6'b01_1111;
					counta <= COUNT_HRH;
					DISP_DP <= DISP_P[5];
					if (MS_F)
						scan_st <= 0;
				end 
			default:
				scan_st <= 0;
		endcase

always @ (*)
	case (counta)
		0:	seven_seg_ra <= 7'b100_0000;
		1:	seven_seg_ra <= 7'b111_1001;
		2:	seven_seg_ra <= 7'b010_0100;
		3:	seven_seg_ra <= 7'b011_0000;
		4:	seven_seg_ra <= 7'b001_1001;
		5:	seven_seg_ra <= 7'b001_0010;
		6:	seven_seg_ra <= 7'b000_0010;
		7:	seven_seg_ra <= 7'b111_1000;
		8:	seven_seg_ra <= 7'b000_0000;
		9:	seven_seg_ra <= 7'b001_0000;
		default:seven_seg_ra <= 7'b100_0000;
	endcase
always @ (posedge SYS_CLK)
	SEVEN_SEGA <= seven_seg_ra; 

endmodule