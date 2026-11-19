`timescale 1ns / 1ps

//============================================================
// STEP 1 - Dual-port memory
// Written on wclk, read combinationally (address in rclk domain).
//============================================================
module fifo_mem (
    input             wclk,
    input             wclken,
    input      [3:0]  waddr,
    input      [7:0]  wdata,
    input      [3:0]  raddr,
    output     [7:0]  rdata
);

    reg [7:0] mem [0:15];

    assign rdata = mem[raddr];
    integer k;
    initial for (k = 0; k < 16; k = k + 1) mem[k] = 8'd0; 

    always @(posedge wclk) begin
        if (wclken)
            mem[waddr] <= wdata;
    end

endmodule


//============================================================
// STEP 2 - Synchronisers
//============================================================
module sync_w2r (
    input            rclk,
    input            rrst_n,
    input      [4:0] wr_gray,
    output reg [4:0] wr_gray_sync
);
    reg [4:0] stage1;

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            stage1       <= 5'b0;
            wr_gray_sync <= 5'b0;
        end
        else begin
            stage1       <= wr_gray;
            wr_gray_sync <= stage1;
        end
    end
endmodule


module sync_r2w (
    input            wclk,
    input            wrst_n,
    input      [4:0] rd_gray,
    output reg [4:0] rd_gray_sync
);
    reg [4:0] stage1;

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            stage1       <= 5'b0;
            rd_gray_sync <= 5'b0;
        end
        else begin
            stage1       <= rd_gray;
            rd_gray_sync <= stage1;
        end
    end
endmodule


//============================================================
// STEP 3 - Write pointer, Gray conversion, full flag
//============================================================
module wptr_full (
    input            wclk,
    input            wrst_n,
    input            winc,
    input      [4:0] rd_gray_sync,
    output     [3:0] waddr,
    output reg [4:0] wr_gray,
    output reg       full
);

    reg [4:0] wr_bin;

    wire [4:0] wr_bin_next  = wr_bin + (winc && !full);
    wire [4:0] wr_gray_next = wr_bin_next ^ (wr_bin_next >> 1);

    assign waddr = wr_bin[3:0];

    wire full_next = (wr_gray_next == {~rd_gray_sync[4:3], rd_gray_sync[2:0]});

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wr_bin  <= 5'b0;
            wr_gray <= 5'b0;
            full    <= 1'b0;
        end
        else begin
            wr_bin  <= wr_bin_next;
            wr_gray <= wr_gray_next;
            full    <= full_next;
        end
    end

endmodule


//============================================================
// STEP 4 - Read pointer, Gray conversion, empty flag
//============================================================
module rptr_empty (
    input            rclk,
    input            rrst_n,
    input            rinc,
    input      [4:0] wr_gray_sync,
    output     [3:0] raddr,
    output reg [4:0] rd_gray,
    output reg       empty
);

    reg [4:0] rd_bin;

    wire [4:0] rd_bin_next  = rd_bin + (rinc && !empty);
    wire [4:0] rd_gray_next = rd_bin_next ^ (rd_bin_next >> 1);

    assign raddr = rd_bin[3:0];

    wire empty_next = (rd_gray_next == wr_gray_sync);

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rd_bin  <= 5'b0;
            rd_gray <= 5'b0;
            empty   <= 1'b1;
        end
        else begin
            rd_bin  <= rd_bin_next;
            rd_gray <= rd_gray_next;
            empty   <= empty_next;
        end
    end

endmodule


//============================================================
// STEP 5 - Top level
//============================================================
module async_fifo (
    input        wclk,
    input        wrst_n,
    input        winc,
    input  [7:0] wdata,
    output       wfull,

    input        rclk,
    input        rrst_n,
    input        rinc,
    output [7:0] rdata,
    output       rempty
);

    wire [3:0] waddr, raddr;
    wire [4:0] wr_gray, rd_gray;
    wire [4:0] wr_gray_sync, rd_gray_sync;

    fifo_mem u_mem (
        .wclk   (wclk),
        .wclken (winc && !wfull),
        .waddr  (waddr),
        .wdata  (wdata),
        .raddr  (raddr),
        .rdata  (rdata)
    );

    wptr_full u_wptr (
        .wclk         (wclk),
        .wrst_n       (wrst_n),
        .winc         (winc),
        .rd_gray_sync (rd_gray_sync),
        .waddr        (waddr),
        .wr_gray      (wr_gray),
        .full         (wfull)
    );

    sync_r2w u_sync_r2w (
        .wclk         (wclk),
        .wrst_n       (wrst_n),
        .rd_gray      (rd_gray),
        .rd_gray_sync (rd_gray_sync)
    );

    rptr_empty u_rptr (
        .rclk         (rclk),
        .rrst_n       (rrst_n),
        .rinc         (rinc),
        .wr_gray_sync (wr_gray_sync),
        .raddr        (raddr),
        .rd_gray      (rd_gray),
        .empty        (rempty)
    );

    sync_w2r u_sync_w2r (
        .rclk         (rclk),
        .rrst_n       (rrst_n),
        .wr_gray      (wr_gray),
        .wr_gray_sync (wr_gray_sync)
    );

endmodule
