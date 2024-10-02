module module_fsm (
    input wire clk,                   // Reloj
    input wire rst,                   // Reset
    input wire [3:0] input_signal,    // Señal de entrada (puede ser un dipswitch o botón)
    input wire [7:0] dipswitch,        // Dipswitch de 8 bits
    input wire [11:0] num1_hex,       // Primer número de entrada en hexadecimal
    input wire [11:0] num2_hex,       // Segundo número de entrada en hexadecimal
    output reg [12:0] sum_result,     // Resultado de la suma (13 bits)
    output reg [1:0] state            // Estado de salida
);

    // Definición de estados
    localparam STATE_IDLE = 2'b00;
    localparam STATE_ACTIVE = 2'b01;
    localparam STATE_FINISH = 2'b10;

    // Estado actual y siguiente
    reg [1:0] current_state, next_state;

    // Lógica de transición de estado
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= STATE_IDLE; // Reiniciar al estado inicial
            sum_result <= 0;              // Reiniciar el resultado
        end else begin
            current_state <= next_state; // Transición al siguiente estado
        end
    end

    // Lógica de salida y siguiente estado
    always @(*) begin
        // Inicializar next_state
        next_state = current_state; // Por defecto, mantenerse en el estado actual
        case (current_state)
            STATE_IDLE: begin
                // Activar si el dipswitch en el bit 0 está encendido
                if (dipswitch[0]) begin
                    next_state = STATE_ACTIVE; // Transición al estado activo
                    sum_result = 0; // Reiniciar resultado en estado IDLE
                end
            end
            STATE_ACTIVE: begin
                // Realizar la suma si el dipswitch en el bit 1 está encendido
                if (dipswitch[1]) begin
                    sum_result = num1_hex + num2_hex; // Calcular la suma
                end
                next_state = STATE_FINISH; // Transición al estado de finalización
            end
            STATE_FINISH: begin
                next_state = STATE_IDLE; // Volver al estado inicial
            end
            default: begin
                next_state = STATE_IDLE; // Manejo de estado no válido
            end
        endcase
    end

    // Asignación de salida de estado
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STATE_IDLE; // Reiniciar el estado
        end else begin
            state <= current_state; // Salida del estado actual
        end
    end

endmodule




