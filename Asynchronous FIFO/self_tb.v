
module self_tb();
reg wclk=0,rclk=0,wrst_n=0,rrst_n=0,winc=0,rinc=0;
reg [7:0]wdata=0;
wire [7:0]rdata;
wire wfull,rempty;
reg [7:0]mem_cpy[0:31];   // copy of what the fifo should hold
integer i,j,wp,rp,error;
parameter wcycle=7;       // write clock 7 ns
parameter rcycle=11;      // read clock 11 ns
parameter thold=1;
async_fifo uut (.wclk(wclk), .wrst_n(wrst_n), .winc(winc), .wdata(wdata), .wfull(wfull), .rclk(rclk), .rrst_n(rrst_n), .rinc(rinc), .rdata(rdata), .rempty(rempty));
always #(wcycle/2.0)wclk=~wclk;
always #(rcycle/2.0)rclk=~rclk;
task reset();
begin
wrst_n=1'b0;
rrst_n=1'b0;
wp=0;
rp=0;
for(j=0;j<32;j=j+1)
mem_cpy[j]=8'd0;
#20;
wrst_n=1'b1;
rrst_n=1'b1;
repeat(2)@(posedge rclk);
end
endtask
task write(input [7:0]d);
begin
@(negedge wclk);
winc=1'b1;
wdata=d;
@(posedge wclk);
if(!wfull)begin       // the fifo takes it only when it is not full
mem_cpy[wp]=d;
wp=wp+1;
end
#thold;
winc=1'b0;
end
endtask
task read();
begin
@(negedge rclk);
if(rdata!==mem_cpy[rp])begin
$display("Fail: read %h, expected %h",rdata,mem_cpy[rp]);
error=error+1;
end
else
$display("ok:   read %h",rdata);
rinc=1'b1;
rp=rp+1;
@(posedge rclk);
#thold;
rinc=1'b0;
end
endtask
initial begin
error=0;
reset;
// step 1: after reset the fifo is empty
if(rempty==1 && wfull==0) 
$display("ok:   empty after reset");
else begin 
$display("Fail: not empty after reset"); 
error=error+1;
end
// step 2: write 5 bytes
for(i=0;i<5;i=i+1) 
write(i+1);
$display("write pointer = %0d, gray = %b",uut.u_wptr.wr_bin,uut.wr_gray);
// step 3: wait for the pointer to cross, empty must go low
repeat(4)@(posedge rclk);
if(rempty==0)
 $display("ok:   empty went low after the crossing");
else begin 
$display("Fail: still empty after the crossing"); 
error=error+1; 
end
// step 4: read 3 bytes
for(i=0;i<3;i=i+1) 
read;
$display("read pointer = %0d, gray = %b",uut.u_rptr.rd_bin,uut.rd_gray);
// step 5: write until full (2 bytes are inside, so 14 more fit)
repeat(4)@(posedge wclk);
for(i=0;i<14;i=i+1) 
write(i+6);
$display("write pointer = %0d, gray = %b",uut.u_wptr.wr_bin,uut.wr_gray);
if(wfull==1) 
$display("ok:   full after 14 more writes");
else begin 
$display("Fail: not full after 14 more writes"); 
error=error+1; 
end
// step 6: one more write must be blocked
write(8'hEE);
if(wp==19) 
$display("ok:   extra write blocked");
else begin 
$display("Fail: extra write went in"); 
error=error+1; 
end
// step 7: read all 16 bytes back
repeat(4)@(posedge rclk);
for(i=0;i<16;i=i+1) read;
repeat(3)@(posedge rclk);
if(rempty==1) 
$display("ok:   empty again at the end");
else begin 
$display("Fail: not empty at the end"); 
error=error+1; 
end
if(error==0) $display("PASS");
else 
$display("FAIL: %0d errors",error);
$finish;
end
endmodule
