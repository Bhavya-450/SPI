
`timescale 1ns/1ns

module  spi_master (
input [7:0]mosi_data ,
input  wire miso, 
input  wire clk ,
input wire rst ,
input wire start ,

output  reg cs ,
output reg sclk ,
output reg mosi , 
output reg busy, 
output reg done ,
output reg [7:0]miso_data  
);
parameter IDLE = 2'b00,
               CS_LOW= 2'b01,
               TRANSFER= 2'b10,
               CS_HIGH  = 2'b11;

parameter CLK_DIV = 2;
reg [1:0]ps ,ns ;
reg [7:0]tx,rx;
reg[3:0]bit_count;
reg[3:0]clk_count;
//-------------------------------------------------------------------------------------------------------------------------------
always@(posedge clk or posedge rst)begin 
if (rst)
     ps <=  IDLE ;
else 
   ps <= ns ;
end 

//--------------------------clk divider(only active while shifting)------------------------------------------------------------
always@(posedge clk or posedge rst)begin 
if (rst) begin 
                   clk_count  <= 0;
                   sclk <= 0;
end 
else if (ps == TRANSFER)begin
     clk_count <= clk_count +1'b1; 
        

            if(clk_count  == CLK_DIV - 1)begin 
                   clk_count <= 0;
                   sclk  <=  ~sclk;
end 

end 
else begin 
               clk_count  <=  0;
              sclk <= 1'b0;
end 
end // always begin -end 

//-------------TX shift register --------------------------------------------------------------
always@(posedge clk or posedge rst )begin 
  if(rst)begin
             tx <= 8'd0;
           bit_count <= 4'b0;
end 
  else if( ps ==  CS_LOW ) begin 
              tx  <=  mosi_data;
              bit_count  <=  0;
end 
else if (ps == TRANSFER &&  clk_count == CLK_DIV - 1  &&  sclk ==1'b1 && bit_count <8)begin
              bit_count  <=   bit_count   + 1'b1;
end 
end 

//--------------------RX shift register + bit counter ----------------------------------------------------
always@(posedge clk or  posedge rst)begin 
    if(rst)  begin
             rx  <=  8'd0;
end 

else if  (ps == TRANSFER && clk_count == CLK_DIV - 1 &&  sclk == 0 &&  bit_count < 8) begin 
            rx [7-bit_count] <= miso;
          
end 
end

//------------output data--------------------------------------------------------------------------------------------------------------
always@(posedge clk or posedge rst )begin 
    if(rst) begin 
              miso_data <=  8'd0;
              done <= 1'b0;
             busy   <= 1'b0;
end 

else if ( ps == CS_LOW  ||  ps == TRANSFER) begin 
              done <=  1'b0;
               busy <= 1'b1;
end 

else if (ps  == CS_HIGH) begin 
            miso_data  <= rx;
           done <=  1'b1;
          busy  <=  1'b0;
end 

else  begin
            done <= 1'b0;
end 
end

//--------------------NEXT -STATE Logic------------------------------------------
always@(*)begin 
   case (ps)
            IDLE : begin 
            if(start)
                      ns  =  CS_LOW;
           else 
                    ns =   IDLE;
end 

             CS_LOW : begin 
                   ns =   TRANSFER;
              end 

              TRANSFER : begin 
            if(bit_count == 8)
                   ns  =  CS_HIGH;
           else 
                   ns  =  TRANSFER;
end 

              CS_HIGH : begin 
                       ns =  IDLE;
end 
               default :  begin 
                        ns  = IDLE;
end
endcase 
end 

//-------------------------------------output logic with cs , mosi---------------------------

always@(*)begin 
   case (ps)  
           IDLE : begin 
              cs = 1'b1;
               mosi = 1'b1;
end 
            CS_LOW : begin 
                 cs = 1'b0;
                 mosi = 1'b1;
end 
              TRANSFER : begin 
                   cs = 1'b0;
               if(bit_count <8)
                      mosi = tx [7-bit_count];
  else
               mosi = 1;
end
             CS_HIGH : begin 
                      cs = 1'b1;
                      mosi = 1'b1;
end 
              default : begin 
                    cs = 1'b1;
                   mosi = 1'b1;
end 
endcase 
end 
endmodule         







