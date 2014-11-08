﻿/*Copyright (c) 2011 Jeroen BeckersPermission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the "Software"), to dealin the Software without restriction, including without limitation the rightsto use, copy, modify, merge, publish, distribute, sublicense, and/or sellcopies of the Software, and to permit persons to whom the Software isfurnished to do so, subject to the following conditions:The above copyright notice and this permission notice shall be included inall copies or substantial portions of the Software.THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS ORIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THEAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHERLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS INTHE SOFTWARE.*/package be.dauntless.astar.basic3d.analyzers {	import be.dauntless.astar.basic2d.IPositionTile;	import be.dauntless.astar.basic2d.IWalkableTile;	import be.dauntless.astar.basic3d.GravityMap3D;	import be.dauntless.astar.basic3d.IWalkable3DTile;	import be.dauntless.astar.basic3d.Point3D;	import be.dauntless.astar.core.Analyzer;	import be.dauntless.astar.core.IAstarTile;	import be.dauntless.astar.core.PathRequest;	/**	 * @author Jeroen	 */	public class FullClipping3DAnalyzer extends Analyzer 	{				private var _ignoreEnd:Boolean;				public function FullClipping3DAnalyzer(ignoreEnd:Boolean = false)		{			_ignoreEnd = ignoreEnd;		}		override public function analyzeTile(tile: IAstarTile, req:PathRequest):Boolean		{			if(_ignoreEnd && (req.isTarget(tile))) return true;						return (tile as IWalkableTile).getWalkable();			}						override protected function analyze(mainTile : IAstarTile, allNeighbours:Vector.<IAstarTile>, neighboursLeft : Vector.<IAstarTile>, req:PathRequest) : Vector.<IAstarTile>		{			var newLeft:Vector.<IAstarTile> = new Vector.<IAstarTile>();						var mainPos:Point3D = Point3D((mainTile as IPositionTile).getPosition());						for(var i:Number = 0; i<neighboursLeft.length; i++)			{				var targetPos : Point3D = Point3D((neighboursLeft[i] as IPositionTile).getPosition());				var b:Boolean = true;				var j:int;								if(targetPos.z == mainPos.z)				{					//same level. Only go horizontal or diagonal					if(targetPos.x == mainPos.x || targetPos.y == mainPos.y)					{						newLeft.push(neighboursLeft[i]);						}				}				else				{					//different level. x and y have to be equal					if(targetPos.x == mainPos.x && targetPos.y == mainPos.y)					{						newLeft.push(neighboursLeft[i]);					}					}			}			return newLeft;		}	}}