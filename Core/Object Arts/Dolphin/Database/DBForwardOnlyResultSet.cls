"Filed out from Dolphin Smalltalk X6"!

DBResultSet subclass: #DBForwardOnlyResultSet
	instanceVariableNames: 'position'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DBForwardOnlyResultSet guid: (GUID fromString: '{BDEB3BCD-B383-4BBB-A02A-E63B31338641}')!
DBForwardOnlyResultSet comment: 'DBForwardOnlyResultSet is the class of <DBResultSet>s specialised to represent forward-only cursors. Forward-only cursors offer much higher performance, especially against large result sets and/or when operating remotely. Backwards navigation and random access are supported, but may be extrememly slow since the query must be re-run and then the result set stepped through once more to the requested position. Since backwards navigation requires a re-query, the result set will not be "static" and will be affected by any updates, insertions or deletions that have been performed since the initial query.

Note that forward-only cursors typically tie up the entire connection against which they were executed until they are closed. This may make it necessary to open multiple connections when using forward-only cursors.

Instance Variables:
	<position>	<integer> position in the result set, one being the first row.
'!
!DBForwardOnlyResultSet categoriesForClass!ODBC Interface! !
!DBForwardOnlyResultSet methodsFor!

bind: anArrayOfColNums
	"Private - Create and bind a buffer to hold the
	specified columns (or #() for all columns)
	as they are fetched from the result set"

	super bind: anArrayOfColNums.
	position := 0.!

close
	"Close the statement which generated the receiver."

	super close.
	position := 0!

free
	"Free the statement which generated the receiver and any other
	resources associated with the receiver itself."

	super free.
	position := 0!

moveFirst
	"Private - If not at the start of the result set, then re-exec the statement."

	^position == 1
		ifTrue: [0]
		ifFalse: [
			position > 0 ifTrue: [self requery].
			self moveNext]!

moveLast
	"Private - Scroll to the last row of the receiver's result set.
	Answer the <integer> row status value."

	| status lastStatus |
	[(status := self moveNext) notNil] whileTrue: [lastStatus := status].
	^lastStatus!

moveNext
	"Private - Advance to the next row in the result set."

	| status |
	status := self fetchScroll: SQL_FETCH_NEXT offset: 0.
	status notNil ifTrue: [position := position + 1].
	^status!

movePrevious
	"Private - Scroll to the previous row of the receiver's result set.
	Answer the <integer> row status value."

	self moveTo: position - 1!

moveTo: anInteger 
	| status |
	position = anInteger 
		ifTrue: [status := 0]
		ifFalse: 
			[anInteger < 1 ifTrue: [^self errorSubscriptBounds: anInteger].
			position > anInteger ifTrue: [self requery].
			[position < anInteger and: [(status := self moveNext) notNil]] whileTrue].
	^status!

onStartup
	"Private - The system is starting. Clear down any invalid external
	resources so that they are lazily reallocated on demand,etc."

	super onStartup.
	position := 0.!

requery
	"Private - Cause a requery to occur lazily on the next access by closing the result set."

	self close!

reverseDo: operation 
	"Evaluate the <monadicValuable> argument, operation, against each 
	element of the receiver in reverse order, from end to start.
	Implementation Note: Override because the superclass definition would
	be very slow for a forward-only cursor. This implementation trades
	memory (since it needs to reify the entire result set) for speed (since
	it only moves forward through the result set)."

	^self asOrderedCollection reverseDo: operation! !
!DBForwardOnlyResultSet categoriesFor: #bind:!binding!private! !
!DBForwardOnlyResultSet categoriesFor: #close!public!realizing/unrealizing! !
!DBForwardOnlyResultSet categoriesFor: #free!public!realizing/unrealizing! !
!DBForwardOnlyResultSet categoriesFor: #moveFirst!operations!private! !
!DBForwardOnlyResultSet categoriesFor: #moveLast!enumerating!private! !
!DBForwardOnlyResultSet categoriesFor: #moveNext!operations!private! !
!DBForwardOnlyResultSet categoriesFor: #movePrevious!enumerating!private! !
!DBForwardOnlyResultSet categoriesFor: #moveTo:!accessing!private! !
!DBForwardOnlyResultSet categoriesFor: #onStartup!event handling!private! !
!DBForwardOnlyResultSet categoriesFor: #requery!operations!private! !
!DBForwardOnlyResultSet categoriesFor: #reverseDo:!enumerating!public! !

