`timescale 1ns / 1ps
module self_tb();
     reg        wclk=0;
     reg        wrst_n=1;
     reg        winc=0;
     reg  [7:0] wdata=0;
    wire        wfull;

     reg        rclk=0;
     reg        rrst_n=1;
     reg        rinc=0;
    wire  [7:0] rdata;
    wire        rempty;
    reg [7:0]mem_cpy[0:31];    // copy of what the fifo should hold, in order
    integer i,j,wp,rp,error;
parameter wcycle=7;            // write clock 7 ns, as in the video
parameter rcycle=11;           // read clock 11 ns, as in the video
parameter thold=2;
parameter tsetup=2;
async_fifo uut(wclk,wrst_n,winc,wdata,wfull,rclk,rrst_n,rinc,rdata,rempty);
   always #(wcycle/2.0)wclk=~wclk;
    always #(rcycle/2.0)rclk=~rclk;
task reset();
begin
wrst_n=1'b0;
rrst_n=1'b0;
wp=0;
rp=0;
for(j=0;j<32;j=j+1)begin
mem_cpy[j]=8'd0;
end
@(posedge wclk);
#thold;
wrst_n=1'b1;
rrst_n=1'b1;
#(wcycle-thold-tsetup);
end
endtask
task write(input [7:0]d);begin
winc=1'b1;
wdata=d;
if(!wfull)begin            // the fifo takes it at this edge only if it is not full
mem_cpy[wp]=d;
wp=wp+1;
end
@(posedge wclk);
#thold;
winc=1'b0;
#(wcycle-thold-tsetup);
end
endtask
task read();begin
rinc=1'b1;
if(rempty)begin
$display("Fail: read while empty");
error=error+1;
end
else if(rdata!==mem_cpy[rp])begin   // rdata already shows the word before the edge
$display("Fail: read %h, expected %h",rdata,mem_cpy[rp]);
error=error+1;
end
else
$display("ok:   read %h",rdata);
if(!rempty) rp=rp+1;
@(posedge rclk);
#thold;
rinc=1'b0;
#(rcycle-thold-tsetup);
end
endtask
initial begin
error=0;
#(wcycle/2.0-tsetup);                   // the first operation starts tsetup before the first edge
reset;
// 1. two clocks, one fifo: empty after reset
if(rempty==1 && wfull==0)
$display("ok:   empty after reset");
else begin 
$display("Fail: not empty after reset"); 
error=error+1; 
end
// 2. each write moves the write pointer: write 5
@(posedge wclk); 
#(wcycle-tsetup);      // line up with the write clock
for(i=0;i<5;i=i+1) write(i+1);
$display("write pointer = %0d, gray = %b",uut.u_wptr.wr_bin,uut.wr_gray);
// 3. it crosses over in gray code: empty turns off
repeat(4)@(posedge rclk);
if(rempty==0) 
$display("ok:   empty turned off after the crossing");
else begin 
$display("Fail: still empty after the crossing"); 
error=error+1; 
end
// 4. the reader follows behind: read 3
@(posedge rclk); #(rcycle-tsetup);      // line up with the read clock
for(i=0;i<3;i=i+1) read;
$display("read pointer = %0d, gray = %b",uut.u_rptr.rd_bin,uut.rd_gray);
// 5. full: one lap ahead (2 bytes inside, so 14 more fit)
repeat(4)@(posedge wclk);
@(posedge wclk); #(wcycle-tsetup);
for(i=0;i<14;i=i+1) write(i+6);
$display("write pointer = %0d, gray = %b",uut.u_wptr.wr_bin,uut.wr_gray);
if(wfull==1) 
$display("ok:   full: 11010 is 00010 with the top 2 bits flipped");
else begin 
$display("Fail: not full"); 
error=error+1; 
end
// 6. one more write while full is blocked
write(8'hEE);
if(wp==19) 
$display("ok:   extra write blocked");
else begin 
$display("Fail: extra write went in"); error=error+1; end
// 7. read all 16 back, in order
repeat(4)@(posedge rclk);
@(posedge rclk); #(rcycle-tsetup);
for(i=0;i<16;i=i+1) read;
repeat(3)@(posedge rclk);
if(rempty==1) 
$display("ok:   empty again");
else begin 
$display("Fail: not empty at the end"); 
error=error+1; 
end
if(error==0) 
$display("PASS");
else
$display("FAIL: %0d errors",error);
$finish;
end
endmodule
