module uart_top 
#(
    parameter BAUD_RATE = 115200
)
(
    input wire clk,
    input wire reset,
    input wire tx_en,
    input wire rx_en,
    input wire [7:0] data_in,
    output wire [7:0] data_out,
    output wire tx_busy,
    output wire rx_busy,
    output wire tx_done,
    output wire rx_done,
    output wire tx_start,
    output wire rx_start
);

    wire rxClock, txClock;
    wire tx_out;

    baud_gen #(
        .BAUD_RATE(BAUD_RATE)
    ) baud_gen_inst (
        .clk(clk),
        .reset(reset),
        .rxClock(rxClock),
        .txClock(txClock)
    );

    uart_tx uart_tx_inst (
        .clk(txClock),
        .reset(reset),
        .tx_en(tx_en),
        .tx_data_in(data_in),
        .tx_data_out(tx_out),
        .start(tx_start),
        .busy(tx_busy),
        .done(tx_done)
    );

    uart_rx uart_rx_inst (
        .clk(rxClock),
        .reset(reset),
        .rx_en(rx_en),
        .rx_data_in(tx_out),
        .rx_data_out(data_out),
        .start(rx_start),
        .busy(rx_busy),
        .done(rx_done)
    );

endmodule