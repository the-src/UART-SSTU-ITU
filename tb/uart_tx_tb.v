module uart_tx_tb;

    reg clk;
    reg reset;
    reg tx_en;
    reg [7:0] tx_data_in;
    wire tx_data_out;
    wire start;
    wire busy;
    wire done;

    uart_tx uut (
        .clk(clk),
        .reset(reset),
        .tx_en(tx_en),
        .tx_data_in(tx_data_in),
        .tx_data_out(tx_data_out),
        .start(start),
        .busy(busy),
        .done(done)
    );

    always #20 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        tx_en = 0;
        tx_data_in = 8'b0;

        #10 reset = 0;
        tx_en = 1;

        // Test case 1: Enable receiver and send data
        tx_data_in = 8'b10101010; // Example data
        @(negedge done);

        // Test case 2: Enable receiver and send data
        tx_data_in = 8'b11001100; // Example data
        @(negedge done);
    

        // Test case 3: Enable receiver and send data
        tx_data_in = 8'b11110000; // Example data
        @(negedge done);


        // Test case 4: Enable receiver and send data
        tx_data_in = 8'b00001111; // Example data
        @(negedge done);

        $finish;
    end

endmodule