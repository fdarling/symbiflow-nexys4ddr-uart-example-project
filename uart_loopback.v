module uart_loopback
    (
        input  wire clk,
        input  wire uart_cts,
        input  wire uart_rts,
        input  wire uart_txd_in,  // FPGA <- FTDI
        output wire uart_rxd_out, // FPGA -> FTDI
        output wire [3:0] led
    );

    // intermediate nets
    wire fpga_uart_tx = uart_txd_in; // loopback for now

    activity_led rx_led_inst (.clk(clk), .in(uart_txd_in),  .out(led[0]));
    activity_led tx_led_inst (.clk(clk), .in(fpga_uart_tx), .out(led[1]));

    assign uart_rxd_out = fpga_uart_tx;
    // inverted because UART idles high
    assign led[2] = ~uart_txd_in;
    assign led[3] = ~fpga_uart_tx;
endmodule
