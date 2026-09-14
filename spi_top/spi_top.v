
 `timescale 1ns/1ns

module SPI_TOP (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,

    input  wire [7:0] master_tx_data,
    input  wire [7:0] slave_tx_data,

    output wire [7:0] master_rx_data,
    output wire [7:0] slave_rx_data,

    output wire       sclk,
    output wire       cs,
    output wire       mosi,
    output wire       miso,

    output wire       master_busy,
    output wire       master_done,
    output wire       slave_done
);

    // SPI Master
    spi_master master_inst (
        .mosi_data (master_tx_data),
        .miso      (miso),
        .clk       (clk),
        .rst       (rst),
        .start     (start),

        .cs        (cs),
        .sclk      (sclk),
        .mosi      (mosi),
        .busy      (master_busy),
        .done      (master_done),
        .miso_data (master_rx_data)
    );

    // SPI Slave
    spi_slave_v2 slave_inst (
        .clk     (clk),
        .rst     (rst),
        .cs      (cs),
        .sclk    (sclk),
        .mosi    (mosi),

        .miso    (miso),

        .tx_data (slave_tx_data),
        .rx_data (slave_rx_data),
        .done    (slave_done)
    );

endmodule
