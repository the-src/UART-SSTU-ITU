module uart_rx_tb;
    reg clk, reset, rx_en, rx_data_in;
    wire [7:0] rx_data_out;
    wire start, busy, done;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // DUT instantiation
    uart_rx uut (
        .clk(clk),
        .reset(reset),
        .rx_en(rx_en),
        .rx_data_in(rx_data_in),
        .rx_data_out(rx_data_out),
        .start(start),
        .busy(busy),
        .done(done)
    );

    // Test stimulus
    initial begin
        // Initialize
        reset = 1;
        rx_en = 0;
        rx_data_in = 1;
        #20;
        reset = 0;
        rx_en = 1;

        // Test Case 1: 10101010
        rx_data_in = 0; #80; // Start bit
        rx_data_in = 0; #80;
        rx_data_in = 1; #80;
        rx_data_in = 0; #80;
        rx_data_in = 1; #80;
        rx_data_in = 0; #80;
        rx_data_in = 1; #80;
        rx_data_in = 0; #80;
        rx_data_in = 1; #80;
        rx_data_in = 1; #80; // Stop bit
        
        // Test Case 2: 11001100
        rx_data_in = 0; #80; // Start bit
        rx_data_in = 0; #80;
        rx_data_in = 0; #80;
        rx_data_in = 1; #80;
        rx_data_in = 1; #80;
        rx_data_in = 0; #80;
        rx_data_in = 0; #80;
        rx_data_in = 1; #80;
        rx_data_in = 1; #80;
        rx_data_in = 1; #80; // Stop bit

        // Test Case 3: 11110000
        rx_data_in = 0; #80; // Start bit
        rx_data_in = 0; #80;
        rx_data_in = 0; #80;
        rx_data_in = 0; #80;
        rx_data_in = 0; #80;
        rx_data_in = 1; #80;
        rx_data_in = 1; #80;
        rx_data_in = 1; #80;
        rx_data_in = 1; #80;
        rx_data_in = 1; #80; // Stop bit

        // Test Case 4: 01010101
        rx_data_in = 0; #80; // Start bit
        rx_data_in = 1; #80;
        rx_data_in = 0; #80;
        rx_data_in = 1; #80;
        rx_data_in = 0; #80;
        rx_data_in = 1; #80;
        rx_data_in = 0; #80;
        rx_data_in = 1; #80;
        rx_data_in = 0; #80;
        rx_data_in = 1; #80; // Stop bit

        #100 $finish;
    end

    // Monitor
    always @(posedge done)
        $display("Time=%0t Received: %b", $time, rx_data_out);

endmodule