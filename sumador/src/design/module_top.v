module module_top # (
     parameter INPUT_REFRESH = 2700000,
     parameter DISPLAY_REFRESH = 27000
)(
    input                  clk_pi,
    input                  rst_pi,

    output  [3 : 0]     anodo_po,
    output  [6 : 0]     catodo_po              

);
    wire [3 : 0] codigo_bin;
    wire [7 : 0] codigo_bcd;

    generate
        module_bin_to_bcd # (4) SUBMODULE_BIN_BCD (
            .clk_i (clk_pi),
            .rst_i (rst_pi),
            .bin_i (codigo_bin),
            .bcd_o (codigo_bcd)
        );

        module_7_segments # (DISPLAY_REFRESH) SUBMODULE_DISPLAY (
            .clk_i    (clk_pi),
            .rst_i    (rst_pi),
            .bcd_i    (codigo_bcd),
            .anodo_o  (anodo_po),
            .catodo_o (catodo_po)    
        );
    endgenerate
    
endmodule
