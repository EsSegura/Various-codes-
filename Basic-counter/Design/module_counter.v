module contador_4bits (
    input logic clk,       // Señal de reloj
    input logic reset,     // Señal de reset (sincrónica)
    output logic [3:0] count // Salida del contador de 4 bits
);

    // Siempre que ocurra un flanco de subida en el reloj, o se active el reset
    always_ff @(posedge clk or posedge reset) begin
        if (reset) 
            count <= 4'b0000;  // Si reset está activo, reiniciar el contador a 0
        else 
            count <= count + 1;  // Incrementar el contador en 1 en cada ciclo de reloj
    end

endmodule
