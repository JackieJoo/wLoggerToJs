
# module::LoggerToJs [![status](https://github.com/Wandalen/wLoggerToJs/workflows/publish/badge.svg)](https://github.com/Wandalen/wLoggerToJs/actions?query=workflow%3Apublish) [![experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/emersion/stability-badges#experimental)

Class to redirect logging to JavaScript structure. Logger supports colorful formatting, verbosity control, chaining, combining several loggers/consoles into logging network. Logger provides 10 levels of verbosity [ 0,9 ] any value beyond clamped and multiple approaches to control verbosity. Logger may use console/stream/process/file as input or output. Unlike alternatives, colorful formatting is cross-platform and works similarly in the browser and on the server side. Use the module to make your diagnostic code working on any platform you work with and to been able to redirect your output to/from any destination/source.

The module in JavaScript provides convenient, layered, logging into data structure.
Logger writes messages( incoming & outgoing ) to data structure( array of arrays ) specified by( outputData ).
Each inner array represent new level of the structure. On write logger puts messages into structure level which is equal to logger level property value.
Creates folders if needed level does not exist logger  it. Next level is always placed at zero index of previous.Then transfers message to the next output(s) object in the chain if it exists.

## Installation
```terminal
npm install wLoggerToJs
```
## Usage
### Options
* outputData { array }[ optional ] - structure where to write messages, creates own structure by default.
* output { object }[ optional ] - single output object for current logger, null by default.

### Methods
Output:
* log
* error
* info
* warn

Leveling:
*  Increase current level - [up](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.up)
*  Decrease current level - [down](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.down)

Chaining:
*  Add object to output list - [outputTo](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.outputTo)
*  Remove object from output list - [outputUnchain](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.outputUnchain)
*  Add current logger to target's output list - [inputFrom](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.inputFrom)
*  Remove current logger from target's output list - [inputUnchain](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.inputUnchain)

Other:
* Check if object exists in logger's inputs list - [hasInput](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.hasInput)
* Check if object exists in logger's outputs list - [hasOutput](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.hasOutput)
* Convert data structure to json string - [toJson](https://rawgit.com/Wandalen/wLoggerToJs/master/doc/reference/wLoggerToJs.html#.toJson)

##### Example #1
```javascript
/* Simple example */
var data = [];
var l = new wLoggerToJs();
/* Increase current level( 0 ) by 2 */
l.log( 'x' );
l.up( 2 );
l.log( 'aa\nbb' );
console.log( l.outputData );
/*
[
  'x',
  [
    [ 'aa\nbb' ]  
  ]
]
*/
```
##### Example #2
```javascript
/* console as input to store it into arrays */
var l = new wLoggerToJs();
l.inputFrom( console );
/* Increase current level by 1 */
l.up( 1 );
console.log( 'aabb' );
console.log( l.toJson() );
/* record console output */
/*
[
  [ 'aabb' ]
]
*/
```
##### Example #3
```javascript
/* another logger as output */
var logger = new wLogger();
var l = new wLoggerToJs
({
  output : logger
});
l.log( 'abc' );
/* logger prints
abc
*/
```





























































