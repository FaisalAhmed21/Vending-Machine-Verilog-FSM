# 10 BDT Vending Machine Controller (FSM)

A robust **Synchronous Moore Finite State Machine (FSM)** implemented in Verilog. This controller is designed for a realistic vending machine that accepts multiple denominations, handles overpayment by returning change, and ensures a stable dispense cycle.

## 🛠 Features
* **Dual Denomination Support:** Accepts `5 BDT` and `10 BDT` inputs.
* **Automatic Change Logic:** Returns `5 BDT` change if the total input reaches `15 BDT`.
* **Synchronous State Transitions:** All logic is tied to the rising edge of the clock to prevent "glitches."
* **Dedicated Dispense State:** Ensures the `out` signal is held high for one full clock cycle, providing enough time for a physical motor to drop the product.

---

## 🧠 State Machine Logic

The "brain" of the machine moves through 5 distinct states based on the cumulative balance:

| State | Amount Held | Action |
| :--- | :--- | :--- |
| **IDLE** | 0 BDT | Waiting for first coin |
| **S_5** | 5 BDT | Remembers 5 BDT; waits for more |
| **S_10** | 10 BDT | Sufficient funds; moving to dispense |
| **S_CHANGE** | 15 BDT | Overpaid; triggers 5 BDT change |
| **DISPENSE** | N/A | Drops bottle and resets to IDLE |

### How it Works (Logic Flow):
1.  **Exact Payment:** User drops two `5 BDT` coins $\rightarrow$ Machine moves `IDLE` $\rightarrow$ `S_5` $\rightarrow$ `S_10` $\rightarrow$ `DISPENSE`.
2.  **Direct Payment:** User drops one `10 BDT` coin $\rightarrow$ Machine moves `IDLE` $\rightarrow$ `S_10` $\rightarrow$ `DISPENSE`.
3.  **Overpayment:** User drops `5 BDT` then `10 BDT` $\rightarrow$ Machine moves `IDLE` $\rightarrow$ `S_5` $\rightarrow$ `S_CHANGE` $\rightarrow$ `DISPENSE`.

---

## 📂 Project Files
* **`design.sv`**: The core Verilog RTL code containing the FSM logic.
* **`testbench.sv`**: The simulation environment with test cases for all payment scenarios.
* **`waveform.png`**: Visual proof of the timing diagram and logic verification.

---

## 🚀 Simulation & Verification
The project was verified using **Icarus Verilog 12.0** on **EDA Playground**.

### To Run Locally:
1.  Ensure you have a Verilog simulator (like Icarus Verilog) installed.
2.  Compile the files: 
    ```bash
    iverilog -o sim design.sv testbench.sv
    ```
3.  Run the simulation: 
    ```bash
    vvp sim
    ```
4.  View the `.vcd` file using **GTKWave** or **EPWave**.

---

## 📊 Results Summary
The simulation confirms:
* **Stability:** No asynchronous glitches; outputs align perfectly with the clock.
* **Memory:** The machine correctly "remembers" previous coins even after the input pulse ends.
* **Accuracy:** Change is only returned when the balance exceeds 10 BDT.

---
*Developed as an exploration of digital logic design and Finite State Machines.*
