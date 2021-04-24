module activity_led
    (
        input wire clk,
        input wire in,
        output wire out
    );

    // inter-modular nets
    wire changed;

    // submodules
    change_detector change_detect_inst (.clk(clk), .in(in), .out(changed));
    pulse_extender pulse_ext_inst (.clk(clk), .in(changed), .out(out));
endmodule
