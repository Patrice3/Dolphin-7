"Filed out from Dolphin Smalltalk X6"!

VirtualMethodCategory subclass: #MethodPrivacyCategory
	instanceVariableNames: 'privacy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodPrivacyCategory guid: (GUID fromString: '{87B4C505-026E-11D3-9FD7-00A0CC3E4A32}')!
MethodPrivacyCategory comment: 'MethodPrivacyCategory is a virtual method category class used to dynamically group private/public methods.

This class has two instances representing the ''private'' and ''public'' categories.

The "privacy" of a method is recorded in the method header flags, and it is those flags which instantiations of this class test against to identify methods with the corresponding privacy level. Every method in the system will be in one or other MethodPrivacyCategory.

Instance Variables:
	privacy	<Integer> bit mask used to compare against the bits of the method headers.

Class Variables:
	None'!
!MethodPrivacyCategory categoriesForClass!Development! !
!MethodPrivacyCategory methodsFor!

acceptsAdditions
	"Answer whether methods can be added to the receiver.
	Although this is a pseudo category, it can accept additions."

	^true!

addMethodSilently: aCompiledMethod 
	"Private - Add the <CompiledMethod> argument to the set of methods that are 
	members of the receiver."

	"Implementation Note: As this is a public/private pseudo category, we just 
	set/reset the private flag on the method"

	aCompiledMethod isPrivate: privacy!

includesMethod: method
	"Answer whether the receiver includes the <CompiledMethod>, method."

	^method isPrivate == privacy!

isPrivacy
	"Private - Answer whether the receiver is a method privacy category."

	^true!

isPseud
	"Answer whether the receiver is a pseudo category (it isn't even though it is virtual)"

	^false!

privacy: anInteger 
	"Private - Set the privacy level represented by the receiver."

	privacy := anInteger!

removeMethodSilently: aCompiledMethod 
	"Private - Remove the <CompiledMethod> argument from the set of 
	methods that are members of the receiver, and make no fuss about it."

	aCompiledMethod isPrivate: privacy not! !
!MethodPrivacyCategory categoriesFor: #acceptsAdditions!public!testing! !
!MethodPrivacyCategory categoriesFor: #addMethodSilently:!adding!private! !
!MethodPrivacyCategory categoriesFor: #includesMethod:!public!testing! !
!MethodPrivacyCategory categoriesFor: #isPrivacy!private!testing! !
!MethodPrivacyCategory categoriesFor: #isPseud!public!testing! !
!MethodPrivacyCategory categoriesFor: #privacy:!accessing!private! !
!MethodPrivacyCategory categoriesFor: #removeMethodSilently:!private!removing! !

!MethodPrivacyCategory class methodsFor!

initialize
	"Private - Initialize the receiver's class variables, etc.
	N.B. This is present to support the Dolphin boot process, it is
	not intended to be re-run subsequently."

	| hermits cave |
	cave := self private.
	hermits := cave contents.
	self removeCategory: 'private'; removeCategory: 'public'.
	Private:= (self newNamed: 'private') privacy: true; yourself.
	Public := (self newNamed: 'public') privacy: false; yourself.
	Table at: Public name put: Public; at: Private name put: Private.
	"N.B. private category now changed"
	cave := self private.
	hermits do: [:hermit | cave addMethodSilently: hermit]!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Public := Private := nil! !
!MethodPrivacyCategory class categoriesFor: #initialize!initializing!private! !
!MethodPrivacyCategory class categoriesFor: #uninitialize!class hierarchy-removing!private! !

