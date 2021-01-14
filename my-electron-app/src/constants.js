// --------- Files Variables & Constants ---------
const NON_PERIPHERAL_COLOR = "non_peripheral_color"
const module_types = [
  {
    type: 'user-defined',
    non_peripheral_color: '#f2f2f2', //if not a peripheral, include a color
  },
  {
    type: 'CPU',
    non_peripheral_color: '#ffffcc', //if not a peripheral, include a color
  },
  {
    type: 'Memory',
    non_peripheral_color: '#e5ffcc', //if not a peripheral, include a color
  }, 
  {type: 'SPI'},
  {type: 'GPIO'},
  {type: 'VGA'},
  {type: 'UART'},
  {type: 'ADC'},
  {type: 'I2C'},
  {type: 'Duplex SAI and CODEC'},
  {type: 'PS/2'},
  {type: 'Composite Video'},
  {type: 'On-Chip Memory'}
]



module.exports = {
    NON_PERIPHERAL_COLOR,
    module_types,
}