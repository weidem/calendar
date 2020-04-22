module dual_num_count
#(parameter PAR_COUNTA=9,
parameter   PAR_COUNTB=5
)
(
	input			 I_SYS_CLK,
	input			 I_EXT_RST,
	input			 I_ADJ_UP,
	input			 I_ADJ_DOWN,
	input	   [1:0] I_ADJ_SEL,
	input			 I_TRIG_F,
	output reg		 O_TRIG_F,
	output reg [3:0] O_COUNTA,
	output reg [3:0] O_COUNTB
);

always @ (posedge I_SYS_CLK)
	if (I_EXT_RST)
	begin
		O_COUNTA <= 0;
		O_COUNTB <= 0;
		O_TRIG_F <= 1'b0;
	end
	else
	begin
		O_TRIG_F <= 1'b0;
		if (I_ADJ_UP)
		begin
			if (!I_ADJ_SEL[0])
			begin
				if (O_COUNTA == PAR_COUNTA)
					O_COUNTA <= 0;
				else
					O_COUNTA <= O_COUNTA + 1;
			end
			else if (!I_ADJ_SEL[1])
				begin
					if (O_COUNTB == PAR_COUNTB)
						O_COUNTB <= 0;
					else
						O_COUNTB <= O_COUNTB + 1;
				end
		end	
		else if (I_ADJ_DOWN)
		begin
				if (!I_ADJ_SEL[0])
				begin
					if (O_COUNTA == 0)
						O_COUNTA <= PAR_COUNTA;
					else
						O_COUNTA <= O_COUNTA - 1;
				end
				else if (!I_ADJ_SEL[1])
				begin
					if (O_COUNTB == 0)
						O_COUNTB <= PAR_COUNTB;
					else
						O_COUNTB <= O_COUNTB - 1;
				end			
		end
		else if (I_TRIG_F)
		begin
			if ((O_COUNTB == PAR_COUNTB) && (O_COUNTA == PAR_COUNTA))
			begin
				O_COUNTA <= 4'd0;
				O_COUNTB <= 0;
				O_TRIG_F <= 1'b1;
			end
			else
			begin
				if (O_COUNTA == 9)
				begin
					O_COUNTA <= 4'd0;
					O_COUNTB <= O_COUNTB + 1;
				end
				else
					O_COUNTA <= O_COUNTA + 1;
			end
		end
	end
endmodule
 
  
