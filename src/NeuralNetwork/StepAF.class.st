Class {
	#name : #StepAF,
	#superclass : #ActivationFunction,
	#type : #variable,
	#category : #NeuralNetwork
}

{ #category : #actions }
StepAF >> derivative: output [
	^ 1
]

{ #category : #actions }
StepAF >> eval: z [
	^ z > 0
		ifTrue: [ 1 ]
		ifFalse: [ 0 ]
]
