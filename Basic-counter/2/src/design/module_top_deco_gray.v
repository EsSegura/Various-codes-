`timescale 1ns / 1ps

module module_top_deco_gray # (
    parameter INPUT_REFRESH = 2700000,  // Frecuencia de actualización para el módulo de decodificación de Gray
    parameter DISPLAY_REFRESH = 27000   // Frecuencia de actualización para el módulo de 7 segmentos
)
(
    input                  clk_pi,          // Señal de reloj de entrada
    input                  rst_pi,          // Señal de reinicio asíncrono de entrada
    input [3 : 0]          codigo_gray_pi,  // Código Gray de 4 bits de entrada
    

    output  [3 : 0]        anodo_po,        // Señal de salida para los ánodos del display de 7 segmentos
    output  [6 : 0]        catodo_po,       // Señal de salida para los cátodos del display de 7 segmentos
    output  [3 : 0]        codigo_bin_led_po,  // Salida del código binario para los LEDs

    
);

    // Definición de señales internas
    wire [3 : 0] codigo_bin;         // Señal interna para el código binario de 4 bits
    wire [7 : 0] codigo_bcd;         // Señal interna para el código BCD de 8 bits (2 dígitos)
    

    // --- Conexiones y generación de bloques ---

    generate
        // Instancia del módulo de decodificación de Gray a binario
        module_input_deco_gray # (4, INPUT_REFRESH) SUBMODULE_INPUT (
            .clk_i         (clk_pi),          // Conexión del reloj de entrada
            .rst_i         (rst_pi),          // Conexión de la señal de reinicio de entrada
            .codigo_gray_i (codigo_gray_pi),  // Conexión del código Gray de entrada
            .codigo_bin_o  (codigo_bin)       // Conexión del código binario de salida
        );

        

        // Instancia del módulo de conversión de binario a BCD
        module_bin_to_bcd # (13) SUBMODULE_BIN_BCD (  // Asegurarse de que 13 bits cubran todo el rango del resultado
            .clk_i (clk_pi),       // Conexión del reloj de entrada
            .rst_i (rst_pi),       // Conexión de la señal de reinicio de entrada
            .bin_i (sum_result_wire), // Conexión del resultado de la suma
            .bcd_o (codigo_bcd)    // Conexión del código BCD de salida
        );

        // Instancia del módulo de control del display de 7 segmentos
        module_7_segments # (DISPLAY_REFRESH) SUBMODULE_DISPLAY (
            .clk_i    (clk_pi),     // Conexión del reloj de entrada
            .rst_i    (rst_pi),     // Conexión de la señal de reinicio de entrada
            .bcd_i    (codigo_bcd), // Conexión del código BCD de entrada
            .anodo_o  (anodo_po),   // Conexión de la salida de los ánodos
            .catodo_o (catodo_po)   // Conexión de la salida de los cátodos
        );

        
    endgenerate

    // Conexión de las entradas capturadas del teclado a la FSM aritmética
    assign num1_internal = key_code[3:0];  // Primer número capturado
    assign num2_internal = key_code[3:0];  // Segundo número capturado (a modificar según implementación)

    // Conexión de la suma a los LEDs
    assign codigo_bin_led_po = ~codigo_bin;  // Mostrar el código binario en LEDs, complementado

endmodule

