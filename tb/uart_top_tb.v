module uart_top_tb;

    reg clk;
    reg reset;
    reg tx_en;
    reg rx_en;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire tx_start, rx_start;
    wire tx_busy, rx_busy;
    wire tx_done, rx_done;

    uart_top #(
        .BAUD_RATE(115200)
    )
    uut (
        .clk(clk),
        .reset(reset),
        .tx_en(tx_en),
        .rx_en(rx_en),
        .data_in(data_in),
        .data_out(data_out),
        .tx_start(tx_start),
        .rx_start(rx_start),
        .tx_busy(tx_busy),
        .rx_busy(rx_busy),
        .tx_done(tx_done),
        .rx_done(rx_done)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        tx_en = 1;
        rx_en = 1;

        #20 reset = 0;

        data_in = 8'b10101010;
        @(negedge tx_done);

        data_in = 8'b01010101;
        @(negedge tx_done);

        data_in = 8'b11110000;
        @(negedge tx_done);

        data_in = 8'b00001111;
        @(negedge tx_done);

        #10000
        $finish;
    end

endmodule