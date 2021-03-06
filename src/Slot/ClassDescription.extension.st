Extension { #name : #ClassDescription }

{ #category : #'*Slot' }
ClassDescription >> superclass: aSuperclass layout: aLayout [
	layout := aLayout. 
	layout slots do: [ :each | each definingClass: self ].
	
	self
		superclass: aSuperclass
		methodDictionary: MethodDictionary new
		format: aLayout format.
]

{ #category : #'*Slot' }
ClassDescription >> superclass: aSuperclass withLayoutType: layoutType slots: slotArray [
	| superLayout newScope newLayout |
	superLayout := aSuperclass
						ifNil: [ EmptyLayout instance ]
						ifNotNil: [ aSuperclass classLayout ].
	newScope := superLayout slotScope extend: slotArray.
	newLayout := layoutType extending: superLayout scope: newScope host: self.
	newLayout checkSanity.
	self
		superclass: aSuperclass
		layout: newLayout
]
