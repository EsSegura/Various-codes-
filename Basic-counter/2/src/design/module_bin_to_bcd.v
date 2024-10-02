module module_bin_to_bcd # (
    parameter WIDTH = 12 // Ajustar el ancho a 12 bits para manejar hasta 4095
)(
    input clk_i,
    input rst_i,
    input [WIDTH - 1 : 0] bin_i,
    output reg [11 : 0] bcd_o // Cambiar a 12 bits para almacenar miles
);
    
    // Señales internas
    reg [15 : 0] double_dabble_r; // Ajustar tamaño para manejar hasta 3 dígitos BCD
    reg [3 : 0] shift_count; // Cambiar a 4 bits para soportar más desplazamientos
    reg ready;

    // FSM para el algoritmo de doble desplazamiento
    reg [2 : 0] state;

    localparam IDLE          = 0;
    localparam SUMA_MILARES  = 1;
    localparam SUMA_CENTENAS = 2;
    localparam SUMA_DECENAS  = 3;
    localparam SUMA_UNIDADES  = 4;
    localparam SHIFT         = 5;
    localparam FIN           = 6;

// Mux para elegir la fuente de bcd_o
always @ (posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
        bcd_o <= 0;
    end else begin
        // Supongamos que tienes alguna condición que decide qué registro usar
        if (some_condition) begin
            bcd_o[7] <= some_value_from_first_source;
        end else begin
            bcd_o[7] <= some_value_from_second_source;
        end
    end
end
    always @ (posedge clk_i) begin
        if (!rst_i) begin
            state           <= IDLE;
            double_dabble_r <= 0;
            shift_count     <= 4; // Ajustar a 4 para más desplazamientos
            ready           <= 0;
        end else begin
            case (state)
                IDLE: begin
                    double_dabble_r[3 : 0]  <= bin_i[3 : 0]; // Asignar las unidades
                    double_dabble_r[7 : 4]  <= 0; // Centenas
                    double_dabble_r[11 : 8] <= 0; // Decenas
                    double_dabble_r[15 : 12] <= 0; // Milares
                    shift_count              <= 4; // Preparar para 4 desplazamientos
                    ready                    <= 0;
                    state                    <= SUMA_MILARES;
                end

                SUMA_MILARES: begin
                    if (double_dabble_r[15 : 12] > 4) begin
                        double_dabble_r[15 : 12] <= double_dabble_r[15 : 12] + 3;
                    end
                    state <= SUMA_CENTENAS;
                end

                SUMA_CENTENAS: begin
                    if (double_dabble_r[11 : 8] > 4) begin
                        double_dabble_r[11 : 8] <= double_dabble_r[11 : 8] + 3;
                    end
                    state <= SUMA_DECENAS;
                end

                SUMA_DECENAS: begin
                    if (double_dabble_r[7 : 4] > 4) begin
                        double_dabble_r[7 : 4] <= double_dabble_r[7 : 4] + 3;
                    end
                    state <= SUMA_UNIDADES;
                end

                SUMA_UNIDADES: begin
                    if (double_dabble_r[3 : 0] > 4) begin
                        double_dabble_r[3 : 0] <= double_dabble_r[3 : 0] + 3;
                    end
                    state <= SHIFT;
                end

                SHIFT: begin
                    double_dabble_r <= double_dabble_r << 1; // Desplazar
                    shift_count <= shift_count - 1;
                    if (shift_count == 0) begin
                        ready <= 1;
                        state <= FIN;
                    end else begin
                        state <= SUMA_MILARES; // Regresar al inicio para el siguiente ciclo
                    end
                end

                FIN: begin
                    bcd_o[3 : 0] <= double_dabble_r[7 : 4];   // Unidades
                    bcd_o[7 : 4] <= double_dabble_r[11 : 8];  // Decenas
                    bcd_o[11 : 8] <= double_dabble_r[15 : 12]; // Milares
                    state <= IDLE; // Regresar al estado inicial
                end

                default: begin
                    state <= IDLE;
                    double_dabble_r <= 0;
                    shift_count <= 4;
                    ready <= 0;
                end
            endcase
        end
    end

    always @ (posedge clk_i) begin
        if (!rst_i) begin
            bcd_o <= 0;
        end else begin
            if(ready) begin
                bcd_o[3 : 0] <= double_dabble_r[7 : 4];  // Unidades
                bcd_o[7 : 4] <= double_dabble_r[11 : 8]; // Decenas
                bcd_o[11 : 8] <= double_dabble_r[15 : 12]; // Milares
            end else begin
                bcd_o <= bcd_o; // Mantener valor anterior
            end
        end   
    end
endmodule
