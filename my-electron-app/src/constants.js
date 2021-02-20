// --------- Files Variables & Constants ---------
const NON_PERIPHERAL_COLOR = "non_peripheral_color"
const MOD_ID_PREFIX = "mod_"
const PARAMETERS = "parameters"
const PARAMNAME = "paramName"
const PARAMTYPE = "paramType"
const DEFAULT = "default"
const UUID = "UUID"
const MODULE_TYPE = "moduleType"
const INSTANCE_NAME = "Verilog Instance Name"
// const module_types = [
//   {
//     type: 'user-defined',
//     non_peripheral_color: '#f2f2f2', //if not a peripheral, include a color
//   },
//   {
//     type: 'CPU',
//     non_peripheral_color: '#ffffcc', //if not a peripheral, include a color
//   },
//   {
//     type: 'Memory',
//     non_peripheral_color: '#e5ffcc', //if not a peripheral, include a color
//   }, 
//   {type: 'SPI'},
//   {type: 'GPIO'},
//   {type: 'VGA'},
//   {type: 'UART'},
//   {type: 'ADC'},
//   {type: 'I2C'},
//   {type: 'Duplex SAI and CODEC'},
//   {type: 'PS/2'},
//   {type: 'Composite Video'},
//   {type: 'On-Chip Memory'}
// ]


// --------- JSON ---------
//import * as data from './components/verilog_generation/IP_database.json'
const data = require('./components/verilog_generation/IP_database.json')
const IP_database = data

module.exports = {
    NON_PERIPHERAL_COLOR,
    MOD_ID_PREFIX,
    PARAMETERS,
    PARAMNAME,
    PARAMTYPE,
    DEFAULT,
    UUID,
    MODULE_TYPE,
    INSTANCE_NAME,
    //module_types,
    IP_database,
}