module change_detector
    (
        input wire clk,
        input wire in,
        output reg out
    );

    reg last;

    wire out_next = (in != last);

    initial begin
        last = 0;
        out = 0;
    end

    always @(posedge clk) begin
        last <= in;
        out <= out_next;
    end
endmodule
