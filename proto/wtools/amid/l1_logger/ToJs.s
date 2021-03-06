(function _ToJs_s_()
{

'use strict';

/**
 * Class to redirect logging to JavaScript structure. Logger supports colorful formatting, verbosity control, chaining, combining several loggers/consoles into logging network. Logger provides 10 levels of verbosity [ 0,9 ] any value beyond clamped and multiple approaches to control verbosity. Logger may use console/stream/process/file as input or output. Unlike alternatives, colorful formatting is cross-platform and works similarly in the browser and on the server side. Use the module to make your diagnostic code working on any platform you work with and to been able to redirect your output to/from any destination/source.
  @module Tools/base/printer/ToJs
*/

/**
 *  */

// require

if( typeof module !== 'undefined' )
{

  let _ = require( './../../../wtools/Tools.s' );

  _.include( 'wLogger' );

}

let levelSymbol = Symbol.for( 'level' );

//

/**
 *
 *
 * Each inner array represent new level of the structure. On write logger puts messages into structure level which is equal to logger level property value.<br>
 * If needed level not exists logger creates it. Next level is always placed at zero index of previous.<br>
 * <br><b>Methods:</b><br><br>
 * Output:
 * <ul>
 * <li>log
 * <li>error
 * <li>info
 * <li>warn
 * </ul>
 * Leveling:
 * <ul>
 *  <li>Increase current level [up]{@link wLoggerMid.up}
 *  <li>Decrease current level [down]{@link wLoggerMid.down}
 * </ul>
 * Chaining:
 * <ul>
 *  <li>Add object to output list [outputTo]{@link wLoggerMid.outputTo}
 *  <li>Remove object from output list [outputUnchain]{@link wLoggerMid.outputUnchain}
 *  <li>Add current logger to target's output list [inputFrom]{@link wLoggerMid.inputFrom}
 *  <li>Remove current logger from target's output list [inputUnchain]{@link wLoggerMid.inputUnchain}
 * </ul>
 * Other:
 * <ul>
 * <li>Convert data structure to json string [toJson]{@link wPrinterToJs.toJson}
 * </ul>
 * @classdesc Subclass of Logger. It writes messages( incoming & outgoing ) to own data structure( array of arrays ). Based on [wLoggerTop]{@link wLoggerTop}.
 *
 * @param { Object } o - Options.
 * @param { Object } [ o.output=null ] - Specifies single output object for current logger.
 * @param { Object } [ o.outputData=[ ] ] - Specifies where to write messages.
 *
 * @example
 * let l = new wPrinterToJs();
 * l.log( '1' );
 * l.outputData; //returns [ '1' ]
 *
 * @example
 * let data = [];
 * let l = new wPrinterToJs({ outputData : data });
 * l.log( '1' );
 * console.log( data ); //returns [ '1' ]
 *
 * @example
 * let l = new wPrinterToJs({ output : console });
 * l.log( '1' ); // console prints '1'
 * l.outputData; //returns [ '1' ]
 *
 * @class wPrinterToJs
 * @namespace Tools
 * @module Tools/base/printer/ToJs
 */
let _global = _global_;
let _ = _global_.wTools;
let Parent = _.Logger;
let Self = wPrinterToJs;
function wPrinterToJs( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'PrinterToJs';

//

function init( o )
{
  let self = this;

  Parent.prototype.init.call( self, o );

  self._currentContainer = self.outputData;

}

//

function write()
{
  let self = this;

  debugger;
  let o = _.LoggerBasic.prototype.write.apply( self, arguments );

  if( !o )
  return;

  _.assert( o );
  _.assert( _.arrayIs( o.output ) );
  _.assert( o.output.length === 1 );

  let terminal = o.output[ 0 ];
  if( self.usingTags && _.mapKeys( self.attributes ).length )
  {

    let text = terminal;
    terminal = Object.create( null );
    terminal.text = text;

    for( let t in self.attributes )
    {
      terminal[ t ] = self.attributes[ t ];
    }

  }

  this._currentContainer.push( terminal );

  return o;
}

//

function _transformEnd( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  // debugger

  o = Parent.prototype._transformEnd.call( self, o );

  if( !o )
  return;

  _.assert( _.arrayIs( o._outputForTerminal ) );
  _.assert( o._outputForTerminal.length === 1 );

  let terminal = o._outputForTerminal[ 0 ];
  if( self.usingTags && _.mapKeys( self.attributes ).length )
  {

    let text = terminal;
    terminal = Object.create( null );
    terminal.text = text;

    for( let t in self.attributes )
    {
      terminal[ t ] = self.attributes[ t ];
    }

  }

  self._currentContainer.push( terminal );

  return o;
}

//

function levelSet( level )
{
  let self = this;

  _.assert( level >= 0, 'levelSet : cant go below zero level to', level );
  _.assert( isFinite( level ) );

  // function _changeLevel( arr, level )
  // {
  //   if( !level )
  //   return arr;
  //
  //   if( !arr[ 0 ] )
  //   arr[ 0 ] = [ ];
  //   else if( !_.arrayIs( arr[ 0 ] ) )
  //   arr.unshift( [] );
  //
  //   return _changeLevel( arr[ 0 ], --level );
  // }

  let dLevel = level - self[ levelSymbol ];

  // Parent.prototype.levelSet.call( self,level );

  if( dLevel > 0 )
  {
    for( let l = 0 ; l < dLevel ; l++ )
    {
      let newContainer = [];
      self._currentContainers.push( self._currentContainer );
      self._currentContainer.push( newContainer );
      self._currentContainer = newContainer;
    }
  }
  else if( dLevel < 0 )
  {
    self._currentContainer = self._currentContainers[ self._currentContainers.length+dLevel ];
    _.assert( _.longIs( self._currentContainer ) || _.objectLike( self._currentContainer ) );
    _.assert( self._currentContainers.length >= -dLevel );
    self._currentContainers.splice( self._currentContainers.length+dLevel, self._currentContainers.length );
    if( level === 0 )
    _.assert( self._currentContainers.length === 0 );
  }

  self[ levelSymbol ] = level;
}

//

/**
 * Converts logger data structure to JSON string.
 * @returns Data structure as JSON string.
 *
 * @example
 * let l = new wPrinterToJs();
 * l.up( 2 );
 * l.log( '1' );
 * l.toJson();
 * //returns
 * //[
 * // [
 * //  [ '1' ]
 * // ]
 * //]
 * @method toJson
 * @class wPrinterToJs
 * @namespace Tools
 * @module Tools/base/printer/ToJs
 */

function toJson()
{
  let self = this;
  return _.toStr( self.outputData, { jsonLike : 1 } );
}

// --
// relations
// --

let Composes =
{
  usingTags : 1,
  // writingAttributesIntoTerminals : 1,
  // writingAttributesIntoBranches : 1,
}

let Aggregates =
{
  outputData : _.define.own( [] ),
}

let Associates =
{
}

let Restricts =
{
  _currentContainer : null,
  _currentContainers : _.define.own( [] ),
}

// --
// prototype
// --

let Proto =
{

  init,

  write,

  _transformEnd,

  levelSet,

  toJson,

  // relations

  /* constructor * : * Self, */
  Composes,
  Aggregates,
  Associates,
  Restricts,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

//

_.accessor.declare
({
  object : Self.prototype,
  names :
  {
    level : 'level',
  },
  combining : 'rewrite'
});

_global_[ Self.name ] = _[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
