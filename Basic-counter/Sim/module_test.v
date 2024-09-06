module tb_contador_4bits;
    logic clk;
    logic reset;
    logic [7:0] count;

    // Instancia del módulo contador
    contador_4bits uut 
    (
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    // Generador de reloj (un ciclo de reloj cada 10 unidades de tiempo)
    always #5 clk = ~clk;

    initial begin
        // Inicialización
        clk = 0;
        reset = 0;

        // Resetear el contador
        #5 reset = 1;
        #10 reset = 0;

        // Simular durante 100 unidades de tiempo
        #100;

        $finish;
    end

    // Mostrar el valor del contador en cada cambio
    always @(count) begin
        $display("Tiempo: %0t | Contador: %0d", $time, count);
    end
endmodule
