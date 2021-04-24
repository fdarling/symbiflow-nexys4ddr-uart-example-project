module pulse_extender
    (
        input wire clk,
        input wire in,
        output reg out
    );

    localparam BITS = 20;
    localparam COOLOFF = 20'd499999;

    // state
    reg [BITS-1:0] counter;

    // next state logic
    wire [BITS-1:0] counter_subbed_saturated = (counter == 0) ? 20'd0 : (counter - 20'd1);
    wire [BITS-1:0] counter_next = in ? COOLOFF : counter_subbed_saturated;
    wire out_next = (counter != 0);

    initial begin
        counter = 0;
        out = 0;
    end

    always @(posedge clk) begin
        counter <= counter_next;
        out <= out_next;
    end
endmodule
