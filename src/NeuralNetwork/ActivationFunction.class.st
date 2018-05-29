Class {
	#name : #ActivationFunction,
	#superclass : #Object,
	#type : #variable,
	#category : #NeuralNetwork
}

{ #category : #actions }
ActivationFunction >> derivative: output [
	^ self subclassResponsibility
]

{ #category : #actions }
ActivationFunction >> eval: z [
	^ self subclassResponsibility
]
