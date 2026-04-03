module vending_machine_tb;
  // Signals
  reg clk;
  reg rst;
  reg [1:0] in;
  wire out;
  wire [1:0] change;

  // Instantiate the Realistic Vending Machine
  vending_machine_21301186 uut (
    .clk(clk),
    .rst(rst),
    .in(in),
    .out(out),
    .change(change)
  );

  // Clock: Toggles every 5ns (10ns period)
  always #5 clk = ~clk;

  initial begin
    // Waveform Setup
    $dumpfile("dump.vcd");
    $dumpvars(0, vending_machine_tb);

    // --- INITIALIZATION ---
    clk = 0;
    rst = 1;
    in = 0;
    #15 rst = 0; // Release reset after 1.5 clock cycles

    // --- SCENARIO 1: Two 5-BDT Coins (Exact 10 BDT) ---
    #10 in = 2'b01; // First 5 BDT
    #10 in = 2'b00; // User releases button/sensor
    #10 in = 2'b01; // Second 5 BDT
    #10 in = 2'b00; // User releases
    #20;            // Wait to see the DISPENSE state cycle

    // --- SCENARIO 2: 10 BDT Direct (Exact 10 BDT) ---
    #10 in = 2'b10; // Insert 10 BDT
    #10 in = 2'b00; 
    #20;            // Wait to see the DISPENSE state cycle

    // --- SCENARIO 3: Overpayment (5 + 10 = 15 BDT) ---
    #10 in = 2'b01; // First 5 BDT
    #10 in = 2'b00;
    #10 in = 2'b10; // Then a 10 BDT coin
    #10 in = 2'b00; 
    #30;            // Wait to see CHANGE and then DISPENSE

    $display("Simulation Finished. Check EPWave for the bottle output!");
    $finish;
  end

endmodule