module vending_machine_21301186(
  input clk,
  input rst,
  input [1:0] in, // 01 = 5 BDT, 10 = 10 BDT
  output reg out,
  output reg [1:0] change
);

  // States: Representing the amount of money currently "held"
  // Using a single parameter block with commas
  parameter IDLE     = 3'b000, 
            S_5      = 3'b001, 
            S_10     = 3'b010, 
            S_CHANGE = 3'b011, 
            DISPENSE = 3'b100; 

  reg [2:0] current_state, next_state;

  // 1. Memory: Moving from one state to the next on the clock pulse
  always @(posedge clk or posedge rst) begin
    if (rst)
      current_state <= IDLE;
    else
      current_state <= next_state;
  end

  // 2. Logic: Deciding the "Next State" based on coins
  always @(*) begin
    case (current_state)
      IDLE: begin
        if (in == 2'b01)      next_state = S_5;
        else if (in == 2'b10) next_state = S_10;
        else                  next_state = IDLE;
      end

      S_5: begin
        if (in == 2'b01)      next_state = S_10;
        else if (in == 2'b10) next_state = S_CHANGE;
        else                  next_state = S_5;
      end

      S_10: begin
        next_state = DISPENSE; // Automatically move to dispense
      end

      S_CHANGE: begin
        next_state = DISPENSE; // Drop bottle after flagging change
      end

      DISPENSE: begin
        next_state = IDLE;     // Reset back to start
      end

      default: next_state = IDLE;
    endcase
  end

  // 3. Output: Synchronous assignments for stability
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      out <= 0;
      change <= 2'b00;
    end else begin
      // Defaults
      out <= 0;
      change <= 2'b00;

      // Output logic based on entering specific states
      if (next_state == DISPENSE) begin
        out <= 1; 
      end
      
      if (next_state == S_CHANGE || current_state == S_CHANGE) begin
        change <= 2'b01; // Return 5 BDT
      end
    end
  end
endmodule