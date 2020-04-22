
module freq_div
(
	input			SYS_CLK,
	input			SYS_RST,
	output	reg		US_F,
	output	reg		MS_F,
	output	reg		S_F
);

reg	[6:0]	us_reg;
reg	[9:0]	ms_reg;
reg	[9:0]	s_reg;

always @ (posedge SYS_CLK)
	if (SYS_RST) 
		begin
			us_reg <= 0;
			US_F <= 1'b0;
		end
	else 
		begin
			US_F <= 1'b0;
			if (us_reg == 99)
				begin
					us_reg <= 0;
					US_F <= 1'b1;
				end
			else 
				us_reg <= us_reg + 1;
		end 

always @ (posedge SYS_CLK)
	if (SYS_RST) 
		begin
			ms_reg <= 0;
			MS_F <= 1'b0;
		end
	else 
		begin
			MS_F <= 1'b0;
			if (US_F) 
				begin
					if (ms_reg == 999)
						begin
							ms_reg <= 0;
							MS_F <= 1'b1;
						end
					else 
						ms_reg <= ms_reg + 1;
				end
		end
	
always @ (posedge SYS_CLK)
	if (SYS_RST) 
		begin
			s_reg <= 0;
			S_F <= 1'b0;
		end
	else 
		begin
			S_F <= 1'b0;
			if (MS_F)
				begin	
					if (s_reg == 999)
						begin
							s_reg <= 0;
							S_F <= 1'b1;
						end
					else 
						s_reg <= s_reg + 1;
				end
	
		end
		
endmodule